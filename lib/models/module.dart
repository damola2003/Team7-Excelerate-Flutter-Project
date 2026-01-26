import 'lesson.dart';

class Module {
  final String id;
  final String title;
  final List<Lesson> lessons;
  bool isExpanded;

  Module({
    required this.id,
    required this.title,
    required this.lessons,
    this.isExpanded = false,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      lessons:
          (json['lessons'] as List<dynamic>?)
              ?.map((lesson) => Lesson.fromJson(lesson as Map<String, dynamic>))
              .toList() ??
          [],
      isExpanded: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}
