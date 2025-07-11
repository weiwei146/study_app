import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_app/assets/MyColors.dart';
import 'package:study_app/view/RegisterScreen.dart';
import '../api/api_service.dart';
import 'Navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isShowPassWord = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _signInFormKey = GlobalKey<FormState>();
  late ApiService apiService;
  bool isLoading = false;

  @override
  void initState() {
    apiService = ApiService();
    super.initState();
  }

  void login() async {
    setState(() {
      isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    bool check = await apiService.login(email, password);

    setState(() {
      isLoading = false;
    });

    if(check) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('isLogin', "true");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Navigation(initialIndex: 0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
            backgroundColor: MyColors.backgroundColor,
            body: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Đăng nhập",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.08,
                        color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Form(
                    key: _signInFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Email hoặc tên người dùng...',
                            hintStyle: const TextStyle(
                                color: Colors.white70
                            ),
                            filled: true,
                            fillColor: MyColors.searchInput,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            errorStyle: const TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Bạn chưa nhập tên tài khoản';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30,),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isShowPassWord,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Mật khẩu...',
                            hintStyle: const TextStyle(
                                color: Colors.white70
                            ),
                            filled: true,
                            fillColor: MyColors.searchInput,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            errorStyle: const TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isShowPassWord
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isShowPassWord = !_isShowPassWord;
                                });
                              },
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Bạn chưa nhập mật khẩu';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30,),
                  GestureDetector(
                    onTap: () {
                      if (_signInFormKey.currentState!.validate()) {
                        login();
                      }
                    },
                    child: Container(
                        width: screenWidth,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: MyColors.loginBtn,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Center(
                    child: TextButton(
                        onPressed: () {

                        },
                        child: Text(
                          "Quên mật khẩu",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                        width: screenWidth,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Tiếp tục với Google',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 15,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisteScreen()));
                    },
                    child: Container(
                        width: screenWidth,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Đăng ký tài khoản mới',
                            style: TextStyle(
                              color: Colors.black,
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


