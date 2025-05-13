class User {
  final String id;
  final String email;
  final String name;
  final String level;
  final bool isLevelAssessed;
  final bool isLearningStarted;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.level,
    required this.isLevelAssessed,
    required this.isLearningStarted,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
      level: json['level'],
      isLevelAssessed: json['isLevelAssessed'],
      isLearningStarted: json['isLearningStarted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'name': name,
      'level': level,
      'isLevelAssessed': isLevelAssessed,
      'isLearningStarted': isLearningStarted,
    };
  }
}