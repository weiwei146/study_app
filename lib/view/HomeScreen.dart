import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_app/assets/MyColors.dart';
import 'package:study_app/view/WordScreen.dart';
import '../api/api_service.dart';
import '../model/Lesson.dart';
import 'QuizScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  List<Lesson> lessons = [];
  late ApiService apiService;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    setState(() {
      isLoading = true;
    });
    apiService.getLessons().then((data) {
      if (mounted) {
        setState(() {
          lessons = data;
          isLoading = false;
        });
      }
    });
  }

  static const Map<String, IconData> iconMap = {
    'chat': Icons.chat,
    'person': Icons.person,
    'home': Icons.home,
    'restaurant': Icons.restaurant,
    'flight': Icons.flight,
    'favorite': Icons.favorite,
    'work': Icons.work,
    'school': Icons.school,
    'nature': Icons.nature,
    'devices': Icons.devices
  };

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SingleChildScrollView (
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30,
            right: 20,
            left: 20,
            bottom: 20
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AbsorbPointer(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: MyColors.searchInput,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: const CupertinoSearchTextField(
                      placeholder: 'Tìm kiếm',
                      backgroundColor: Colors.transparent,
                      borderRadius: BorderRadius.zero,
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Text(
                  " Các học phần",
                  style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 450,
                  child: Stack(
                    children: [
                      ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          ...lessons.map((lesson) => listGrade(lesson!)).toList(),
                        ],
                      ),
                      if (isLoading)
                        Container(
                          color: Colors.transparent,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  )
                ),
                const SizedBox(height: 30,),
                SizedBox(
                  height: screenHeight * 0.3,
                  width: screenWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.backgroundColor,
                      border: Border.all(
                        color: MyColors.searchInput,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.folder,
                            color: Colors.indigo,
                            size: screenWidth * 0.15,
                          ),
                          Text(
                            "Học phần",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Sắp xếp các học phần cho những chủ đề khác nhau mà bạn đang học",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              width: screenWidth,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: MyColors.backgroundColor,
                                border: Border.all(
                                  color: MyColors.searchInput,
                                  width: 4,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Text(
                                  'Thêm học phần',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ),
                          )
                        ],
                      ),
                    )
                  )
                ),
              ],
            ),
        )
      ),
    );
  }
  Widget listGrade(Lesson lesson) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Xác nhận"),
                  content: Text('Lựa chọn yêu cầu của bạn'),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WordScreen(lesson: lesson,)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Học từ vựng'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>QuizScreen(lesson: lesson,)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Làm Quiz'),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: MyColors.backgroundColor,
              border: Border.all(
                color: MyColors.searchInput,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    lesson.description,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      tag(lesson.status),
                      const SizedBox(width: 8),
                      tag("Bài học số " + lesson.lessonNumber.toString()),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Icon(
                        iconMap[lesson.icon] ?? Icons.help,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(lesson.icon, style: const TextStyle(color: Colors.white)),
                      const Spacer(),
                      const Icon(Icons.more_vert, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget tag(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2B4E),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(
              text == "not started" ? "Chưa học" : text,
              style: const TextStyle(
              color: Colors.white,
              fontSize: 12, fontWeight: FontWeight.bold,
           )
          ),
        ],
      ),
    );
  }
}
