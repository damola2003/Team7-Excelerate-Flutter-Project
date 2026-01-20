class Assignment {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String status; // 'Pending', 'Submitted', 'Graded'
  final int? score;
  final int maxScore;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.score,
    required this.maxScore,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: DateTime.parse(
        json['dueDate'] ?? DateTime.now().toIso8601String(),
      ),
      status: json['status'] ?? 'Pending',
      score: json['score'],
      maxScore: json['maxScore'] ?? 100,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'score': score,
      'maxScore': maxScore,
    };
  }
}
