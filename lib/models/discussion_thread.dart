class DiscussionThread {
  final String id;
  final String author;
  final String authorRole;
  final String question;
  final DateTime timestamp;
  final int replies;
  final bool hasInstructorReply;

  DiscussionThread({
    required this.id,
    required this.author,
    required this.authorRole,
    required this.question,
    required this.timestamp,
    required this.replies,
    this.hasInstructorReply = false,
  });

  factory DiscussionThread.fromJson(Map<String, dynamic> json) {
    return DiscussionThread(
      id: json['id'] ?? '',
      author: json['author'] ?? '',
      authorRole: json['authorRole'] ?? 'Student',
      question: json['question'] ?? '',
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      replies: json['replies'] ?? 0,
      hasInstructorReply: json['hasInstructorReply'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'authorRole': authorRole,
      'question': question,
      'timestamp': timestamp.toIso8601String(),
      'replies': replies,
      'hasInstructorReply': hasInstructorReply,
    };
  }
}
