class Lesson {
  final String id;
  final String title;
  final String type; // 'video', 'pdf', 'quiz'
  final String duration;
  final bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.type,
    required this.duration,
    this.isCompleted = false,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? 'video',
      duration: json['duration'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'duration': duration,
      'isCompleted': isCompleted,
    };
  }

  Lesson copyWith({bool? isCompleted}) {
    return Lesson(
      id: id,
      title: title,
      type: type,
      duration: duration,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
