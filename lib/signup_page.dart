import 'package:excelerate/home.dart';
import 'package:flutter/material.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _termsAccepted = false;
  
  // Validation states
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _nameError;

  // Email regex pattern for validation
  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  // Strong password regex (at least 8 chars, 1 uppercase, 1 lowercase, 1 number)
  final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$',
  );

  void _validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
    } else if (!_emailRegex.hasMatch(value)) {
      setState(() {
        _emailError = 'Please enter a valid email address';
      });
    } else {
      setState(() {
        _emailError = null;
      });
    }
  }

  void _validatePassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
    } else if (value.length < 8) {
      setState(() {
        _passwordError = 'Password must be at least 8 characters';
      });
    } else if (!_passwordRegex.hasMatch(value)) {
      setState(() {
        _passwordError = 'Password must contain at least:\n• 1 uppercase letter\n• 1 lowercase letter\n• 1 number';
      });
    } else {
      setState(() {
        _passwordError = null;
      });
    }
  }

  void _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Please confirm your password';
      });
    } else if (value != _passwordController.text) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
      });
    } else {
      setState(() {
        _confirmPasswordError = null;
      });
    }
  }

  void _validateName(String value) {
    if (value.isEmpty) {
      setState(() {
        _nameError = 'Full name is required';
      });
    } else if (value.trim().split(' ').length < 2) {
      setState(() {
        _nameError = 'Please enter your full name';
      });
    } else {
      setState(() {
        _nameError = null;
      });
    }
  }

  bool _isFormValid() {
    return _nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _termsAccepted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blue[800],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Join Learn Sphere',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Create your account to start learning',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              
              // Full Name Field
              Text(
                'Full Name',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _nameError != null ? Colors.red[300]! : Colors.grey[300]!,
                  ),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'John Doe',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    suffixIcon: _nameController.text.isNotEmpty && _nameError == null
                        ? Icon(Icons.check_circle, color: Colors.green[400], size: 20)
                        : null,
                  ),
                  style: const TextStyle(fontSize: 16),
                  onChanged: (value) {
                    _validateName(value);
                  },
                ),
              ),
              if (_nameError != null) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    _nameError!,
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              
              // Email Field
              Text(
                'Email Address',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _emailError != null ? Colors.red[300]! : Colors.grey[300]!,
                  ),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'name@example.com',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    suffixIcon: _emailController.text.isNotEmpty && _emailError == null
                        ? Icon(Icons.check_circle, color: Colors.green[400], size: 20)
                        : null,
                  ),
                  style: const TextStyle(fontSize: 16),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  onChanged: (value) {
                    _validateEmail(value);
                  },
                ),
              ),
              if (_emailError != null) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    _emailError!,
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              
              // Password Field
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _passwordError != null ? Colors.red[300]! : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          hintText: 'Create a strong password',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          suffixIcon: _passwordController.text.isNotEmpty && _passwordError == null
                              ? Icon(Icons.check_circle, color: Colors.green[400], size: 20)
                              : null,
                        ),
                        style: const TextStyle(fontSize: 16),
                        onChanged: (value) {
                          _validatePassword(value);
                          // Also re-validate confirm password
                          if (_confirmPasswordController.text.isNotEmpty) {
                            _validateConfirmPassword(_confirmPasswordController.text);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_passwordError != null) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    _passwordError!,
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                'Password must be at least 8 characters with uppercase, lowercase, and number',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 20),
              
              // Confirm Password Field
              Text(
                'Confirm Password',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _confirmPasswordError != null ? Colors.red[300]! : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          hintText: 'Confirm your password',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          suffixIcon: _confirmPasswordController.text.isNotEmpty && _confirmPasswordError == null
                              ? Icon(Icons.check_circle, color: Colors.green[400], size: 20)
                              : null,
                        ),
                        style: const TextStyle(fontSize: 16),
                        onChanged: (value) {
                          _validateConfirmPassword(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        child: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_confirmPasswordError != null) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    _confirmPasswordError!,
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 30),
              
              // Terms Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                    activeColor: Colors.blue[600],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _termsAccepted = !_termsAccepted;
                            });
                          },
                          child: Text(
                            'I agree to the Terms of Service and Privacy Policy',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Show terms dialog
                                _showTermsDialog(context);
                              },
                              child: Text(
                                'View Terms',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                // Show privacy policy dialog
                                _showPrivacyDialog(context);
                              },
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              // Create Account Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isFormValid() && !_isLoading
                      ? () async {
                          // Final validation
                          _validateName(_nameController.text);
                          _validateEmail(_emailController.text);
                          _validatePassword(_passwordController.text);
                          _validateConfirmPassword(_confirmPasswordController.text);
                          
                          if (!_isFormValid()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fix all errors before submitting'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _isLoading = true;
                          });

                          // Simulate API call
                          await Future.delayed(const Duration(seconds: 2));

                          setState(() {
                            _isLoading = false;
                          });

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Account created successfully!'),
                              backgroundColor: Colors.green[600],
                            ),
                          );

                          // Navigate to home page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid() ? Colors.blue[600] : Colors.grey[400],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Already have account
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Last Updated: ${DateTime.now().toString().split(' ')[0]}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              const Text(
                'By using Learn Sphere, you agree to the following terms:',
              ),
              const SizedBox(height: 12),
              const Text(
                '• You are responsible for maintaining the confidentiality of your account\n\n'
                '• You agree not to share your login credentials\n\n'
                '• All course materials are for personal use only\n\n'
                '• We may update these terms periodically',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Effective: ${DateTime.now().toString().split(' ')[0]}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your privacy is important to us. This policy explains:',
              ),
              const SizedBox(height: 12),
              const Text(
                '• We collect only necessary information\n\n'
                '• Your data is encrypted and secure\n\n'
                '• We do not sell your personal information\n\n'
                '• You can delete your account at any time',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}