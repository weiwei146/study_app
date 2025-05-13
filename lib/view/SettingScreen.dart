import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_app/api/api_service.dart';
import 'package:study_app/assets/MyColors.dart';
import 'package:study_app/model/User.dart';

import 'LoginScreen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late SharedPreferences prefs;
  late String name;
  late String email;
  late String level;
  late bool isLevelAssessed;
  late bool isLearningStarted;
  late User user;
  late ApiService apiService;
  bool isLoading = false;

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('isLogin', "false");
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  void initState() {
    apiService = ApiService();
    name = "";
    email = "";
    level = "";
    isLearningStarted = false;
    isLevelAssessed = false;
    getInformationUser();
    super.initState();
  }

  void getInformationUser() async {
    setState(() {
      isLoading = true;
    });
    user = await apiService.getInformationUser();
    name = user.name;
    email = user.email;
    level = user.level;
    isLearningStarted = user.isLearningStarted;
    isLevelAssessed = user.isLevelAssessed;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
            backgroundColor: MyColors.backgroundColor,
            body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.indigo,
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: const TextStyle(color: Colors.white, fontSize: 40),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Text(
                        "Thông tin người dùng",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Text(
                        "Tên người dùng",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        color: MyColors.textInput,
                        thickness: 2,
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Text(
                        "Email người dùng",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        color: MyColors.textInput,
                        thickness: 2,
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Text(
                        "Level của người dùng",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        color: MyColors.textInput,
                        thickness: 2,
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        level,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Text(
                        "Mức độ đánh giá",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        color: MyColors.textInput,
                        thickness: 2,
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        isLevelAssessed ? "Chưa được đánh giá" : "Tốt",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Text(
                        "Trạng thái học",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        color: MyColors.textInput,
                        thickness: 2,
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        isLearningStarted ? "Đang học" : "Chưa học",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 50,),
                      GestureDetector(
                        onTap: () {
                          logout();
                        },
                        child: Container(
                            width: screenWidth,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Đăng xuất',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                )
            )
        ),
        if (isLoading)
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
