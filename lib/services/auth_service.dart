import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of user authentication state
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Email/Password Sign Up
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );

      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email.trim(),
        'fullName': fullName.trim(),
        'profileImage': '',
        'role': 'student',
        'isEmailVerified': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'authProvider': 'email',
        'enrolledCourses': [],
        'completedLessons': [],
      });

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'Failed to create account. Please try again.';
    }
  }

  // Email/Password Sign In (Only allows verified users)
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Check if email is verified
      if (!userCredential.user!.emailVerified) {
        await _auth.signOut();
        throw 'Please verify your email before logging in. Check your inbox for verification link.';
      }

      // Update last login timestamp
      await _firestore.collection('users').doc(userCredential.user!.uid).update(
        {'lastLogin': FieldValue.serverTimestamp()},
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      rethrow;
    }
  }

  // Google Sign In
  Future<User?> signInWithGoogle() async {
    try {
      // Initialize Google Sign In (required in version 7.x)
      await _googleSignIn.initialize();

      // Trigger Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // Obtain auth details using the new authorization API
      final GoogleSignInClientAuthorization authorization = await googleUser
          .authorizationClient
          .authorizeScopes([
            'https://www.googleapis.com/auth/userinfo.email',
            'https://www.googleapis.com/auth/userinfo.profile',
          ]);

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: authorization.idToken,
      );

      // Sign in to Firebase
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Check if user document exists
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // If new user, create document
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email ?? googleUser.email,
          'fullName': googleUser.displayName ?? 'User',
          'profileImage': googleUser.photoUrl ?? '',
          'role': 'student',
          'isEmailVerified': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'authProvider': 'google',
          'enrolledCourses': [],
          'completedLessons': [],
          'lastLogin': FieldValue.serverTimestamp(),
        });
      } else {
        // Update last login for existing user
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({'lastLogin': FieldValue.serverTimestamp()});
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'Failed to sign in with Google';
    }
  }

  // Apple Sign In
  Future<User?> signInWithApple() async {
    try {
      // Check if Apple Sign In is available
      if (!await SignInWithApple.isAvailable()) {
        throw 'Apple Sign In is not available on this device';
      }

      // Trigger Apple Sign In flow
      final AuthorizationCredentialAppleID result =
          await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

      // Create OAuth credential
      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: result.identityToken,
        accessToken: result.authorizationCode,
      );

      // Sign in to Firebase
      UserCredential userCredential = await _auth.signInWithCredential(
        oAuthCredential,
      );

      // Extract user data from Apple
      String fullName = '';
      if (result.givenName != null && result.familyName != null) {
        fullName = '${result.givenName} ${result.familyName}';
      } else {
        fullName = 'Apple User';
      }

      // Check if user document exists
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // If new user, create document
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': result.email ?? userCredential.user!.email ?? '',
          'fullName': fullName,
          'profileImage': '',
          'role': 'student',
          'isEmailVerified': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'authProvider': 'apple',
          'enrolledCourses': [],
          'completedLessons': [],
          'lastLogin': FieldValue.serverTimestamp(),
        });
      } else {
        // Update last login for existing user
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({'lastLogin': FieldValue.serverTimestamp()});
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'Failed to sign in with Apple: ${e.toString()}';
    }
  }

  // Password Reset
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      throw 'Failed to sign out';
    }
  }

  // Get User Data
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  // Error Handler
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please use a different email or sign in.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'Password is too weak. Must be at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'requires-recent-login':
        return 'Session expired. Please sign in again.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
// mother of our problems, this is the function that checks if the email exists in the database. We will use this to determine whether to show the sign up or sign in screen when the user enters their email.
  Future checkEmailExists(String text) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(text);
      return methods.isNotEmpty;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }
}
//Come back here if we still have issues with the Google Sign In flow. The new API is quite different and may require additional handling for the authorization process.
extension on FirebaseAuth {
  Future fetchSignInMethodsForEmail(String text) async {
    return [];
  }
}

extension on GoogleSignIn {
  Future<GoogleSignInAccount?> signIn() async {
    return null;
  }
}

extension on GoogleSignInClientAuthorization {
  String? get idToken => null;
}
