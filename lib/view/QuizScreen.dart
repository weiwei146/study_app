import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../assets/MyColors.dart';
import '../model/Lesson.dart';

class QuizScreen extends StatefulWidget {
  final Lesson lesson;

  const QuizScreen({super.key, required this.lesson});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
        body: Center(

        )
    );
  }
}
