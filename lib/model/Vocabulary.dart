class Vocabulary {
  final String id;
  final int wordNumber;
  final String word;
  final String meaning;
  final String partOfSpeech;
  final String example;
  final String synonym;
  final String lessonTitle;
  final String level;
  final bool isLearned;

  Vocabulary({
    required this.id,
    required this.wordNumber,
    required this.word,
    required this.meaning,
    required this.partOfSpeech,
    required this.example,
    required this.synonym,
    required this.lessonTitle,
    required this.level,
    required this.isLearned,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      id: json['_id'],
      wordNumber: json['wordNumber'],
      word: json['word'],
      meaning: json['meaning'],
      partOfSpeech: json['partOfSpeech'],
      example: json['example'],
      synonym: json['synonym'],
      lessonTitle: json['lessonTitle'],
      level: json['level'],
      isLearned: json['isLearned'],
    );
  }
}
