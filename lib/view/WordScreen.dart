import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_app/api/TTS_service.dart';
import 'package:study_app/model/Vocabulary.dart';
import '../api/api_service.dart';
import '../assets/MyColors.dart';
import '../model/Lesson.dart';
import 'Navigation.dart';

class WordScreen extends StatefulWidget {
  final Lesson lesson;

  const WordScreen({super.key, required this.lesson});

  @override
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  List<Vocabulary> vocabularies = [];
  late ApiService apiService;
  late TextToSpeechService textToSpeechService;
  int currentQuestion = 1;
  int totalQuestions = 1;
  bool isLoading = false;
  bool isLoadingUpdate = false;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    textToSpeechService = TextToSpeechService();
    setState(() {
      isLoading = true;
    });
    apiService.getWordByLessonId(widget.lesson.title).then((data) {
      if (mounted) {
        setState(() {
          vocabularies = data;
          totalQuestions = vocabularies.length;
          isLoading = false;
        });
      }
    });
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void maskWordOnLesson() async {
    setState(() {
      isLoadingUpdate = true;
    });

    try {
      for (var vocab in vocabularies) {
        await apiService.maskWordOnLesson(vocab.id, vocab.lessonTitle, vocab.level);
      }
      await apiService.maskLesson(widget.lesson.id, widget.lesson.lessonNumber);
    } catch (e) {
      print("Lỗi cập nhật từ: $e");
    }
    if (!mounted) return;

    setState(() {
      isLoadingUpdate = false;
    });
  }


  @override
  void dispose() {
    super.dispose();
    textToSpeechService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
            backgroundColor: MyColors.backgroundColor,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              title: Text(
                widget.lesson.title,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Lượt $currentQuestion", style: TextStyle(color: Colors.white, fontSize: 16)),
                      Text("$currentQuestion / $totalQuestions", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: totalQuestions > 0 ? currentQuestion / totalQuestions : 0,
                      backgroundColor: Colors.white24,
                      color: Colors.greenAccent,
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                      child: Stack(
                        children: [
                          PageView.builder(
                            itemCount: vocabularies.length + 1,
                            onPageChanged: (index) {
                              setState(() {
                                currentQuestion = index + 1;
                              });
                            },
                            itemBuilder: (context, index) {
                              if (index == vocabularies.length) {
                                return !isLoading ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Bạn đã hoàn thành khóa học!',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 30),
                                      ElevatedButton(
                                        onPressed: () {
                                          maskWordOnLesson();
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Navigation(initialIndex: 0)));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text(
                                          'Kết thúc khóa học',
                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ) : Center(
                                  child: Container(
                                    color: MyColors.backgroundColor,
                                  ),
                                );
                              }
                              return Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                capitalizeFirstLetter(vocabularies[index].word),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: screenWidth * 0.05,
                                                    fontWeight: FontWeight.bold
                                                )
                                            ),
                                            const Spacer(),
                                            IconButton(
                                                onPressed: () {
                                                  textToSpeechService.speakTts(vocabularies[index].word);
                                                },
                                                icon: const Icon(Icons.volume_up, color: Colors.orange,)
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                            vocabularies[index].partOfSpeech + " - " + vocabularies[index].level,
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: screenWidth * 0.04,
                                                fontStyle: FontStyle.italic
                                            )
                                        ),
                                        const Divider(
                                          color: Colors.orange,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                            'Mô tả ý nghĩa',
                                            style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: screenWidth * 0.04,
                                            )
                                        ),
                                        Text(
                                            vocabularies[index].meaning,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * 0.04,
                                            )
                                        ),
                                        SizedBox(height: 10),
                                        const Divider(
                                          color: Colors.orange,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                            'Ví dụ',
                                            style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: screenWidth * 0.04,
                                            )
                                        ),
                                        Text(
                                            '${vocabularies[index].example}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * 0.04,
                                            )
                                        ),
                                        SizedBox(height: 10),
                                        const Divider(
                                          color: Colors.orange,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                            'Từ đồng nghĩa',
                                            style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: screenWidth * 0.04,
                                            )
                                        ),
                                        Text(
                                            '${vocabularies[index].synonym}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * 0.04,
                                            )
                                        ),
                                        SizedBox(height: 10),
                                        const Divider(
                                          color: Colors.orange,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                            'Trạng thái',
                                            style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: screenWidth * 0.04,
                                            )
                                        ),
                                        Text(
                                            !vocabularies[index].isLearned ? "Chưa học" : "Đã học",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * 0.04,
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                              );
                            },
                          ),
                          if (isLoading)
                            Container(
                              color: MyColors.backgroundColor,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      )
                  ),
                ],
              ),
            )
        ),
        if (isLoadingUpdate)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
