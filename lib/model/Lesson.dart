class Lesson {
  final String id;
  final String title;
  final int lessonNumber;
  final String icon;
  final String description;
  final String status;

  Lesson({
    required this.id,
    required this.title,
    required this.lessonNumber,
    required this.icon,
    required this.description,
    required this.status,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['_id'],
      title: json['title'],
      lessonNumber: json['lessonNumber'],
      icon: json['icon'],
      description: json['description'],
      status: json['status'],
    );
  }
}