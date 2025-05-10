import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:study_app/assets/MyColors.dart';

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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
                    final email = _emailController.text.trim();
                    final password = _passwordController.text;
                    //goi API login o day
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
    );
  }
}


