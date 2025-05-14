import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:study_app/api/TTS_service.dart';
import 'package:study_app/model/Vocabulary.dart';
import '../api/api_service.dart';
import '../assets/MyColors.dart';
import '../model/Lesson.dart';
import 'Navigation.dart';

class QuizScreen extends StatefulWidget {
  final Lesson lesson;

  const QuizScreen({super.key, required this.lesson});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Vocabulary> vocabularies = [];
  late ApiService apiService;
  late TextToSpeechService textToSpeechService;
  List<FlipCardController> controllers = [];
  int currentQuestion = 1;
  int totalQuestions = 1;
  bool isLoading = false;
  bool isLoadingUpdate = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    textToSpeechService = TextToSpeechService();
    _pageController = PageController();
    setState(() {
      isLoading = true;
    });
    apiService.getWordByLessonId(widget.lesson.title).then((data) {
      if (mounted) {
        setState(() {
          vocabularies = data;
          totalQuestions = vocabularies.length;
          controllers = List.generate(vocabularies.length, (_) => FlipCardController());
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

  String convertPartOfSpeech(String partOfSpeech) {
    partOfSpeech = partOfSpeech.toLowerCase();
    List<String> parts = [];

    if (partOfSpeech.contains("noun")) parts.add("n");
    if (partOfSpeech.contains("verb")) parts.add("v");
    if (partOfSpeech.contains("adjective")) parts.add("adj");
    if (partOfSpeech.contains("adverb")) parts.add("adv");
    if (partOfSpeech.contains("phrasal verb") || partOfSpeech.contains("phrase")) parts.add("phr");
    if (partOfSpeech.contains("pronoun")) parts.add("pron");
    if (partOfSpeech.contains("preposition")) parts.add("prep");
    if (partOfSpeech.contains("conjunction")) parts.add("conj");
    if (partOfSpeech.contains("interjection")) parts.add("interj");
    if (partOfSpeech.contains("determiner")) parts.add("det");
    if (partOfSpeech.contains("article")) parts.add("art");

    return parts.join("/");
  }


  @override
  void dispose() {
    super.dispose();
    textToSpeechService.dispose();
    _pageController.dispose();
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
                            controller: _pageController,
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
                                  padding: const EdgeInsets.all(10),
                                  child: GestureDetector(
                                    onTap: () {
                                      controllers[index].flipcard();
                                    },
                                    child: FlipCard(
                                      frontWidget: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                        padding: const EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF2E3758),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Text(
                                                capitalizeFirstLetter(vocabularies[index].word) + " (" + convertPartOfSpeech(vocabularies[index].partOfSpeech) + ")",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: screenWidth * 0.07
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              left: 0,
                                              child: IconButton(
                                                icon: const Icon(Icons.volume_up, color: Colors.white),
                                                onPressed: () {
                                                  textToSpeechService.speakTts(vocabularies[index].word);
                                                },
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: IconButton(
                                                icon: !vocabularies[index].isLearned ? const Icon(
                                                    Icons.star,
                                                    color: Colors.white
                                                ) : const Icon(
                                                    Icons.star,
                                                    color: Colors.yellow
                                                ),
                                                onPressed: () {

                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      ),
                                      backWidget: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                          padding: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF2E3758),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(20),
                                                child: Center(
                                                  child: Text(
                                                    vocabularies[index].meaning,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: screenWidth * 0.05
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: IconButton(
                                                  icon: !vocabularies[index].isLearned ? const Icon(
                                                      Icons.star,
                                                      color: Colors.white
                                                  ) : const Icon(
                                                      Icons.star,
                                                      color: Colors.yellow
                                                  ),
                                                  onPressed: () {

                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                      controller: controllers[index],
                                      rotateSide: RotateSide.bottom,
                                      onTapFlipping: false,
                                      axis: FlipAxis.horizontal,
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
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                              Icons.keyboard_return,
                              color: Colors.white
                          ),
                          onPressed: () {
                            if (currentQuestion > 1) {
                              _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            }
                          },
                        ),
                        Text(
                          "Chạm vào thẻ để lật",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.035
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                              Icons.skip_next_sharp,
                              color: Colors.white,
                          ),
                          onPressed: () {
                            if (currentQuestion < vocabularies.length + 1) {
                              _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            }
                          },
                        ),
                      ],
                    )
                  )
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
