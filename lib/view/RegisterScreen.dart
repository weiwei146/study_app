import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study_app/api/api_service.dart';
import 'package:study_app/assets/MyColors.dart';
import 'package:study_app/view/LoginScreen.dart';

class RegisteScreen extends StatefulWidget {
  const RegisteScreen({super.key});

  @override
  State<RegisteScreen> createState() => _RegisteScreenState();
}

class _RegisteScreenState extends State<RegisteScreen> {
  bool _isShowPassWord = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController = TextEditingController();
  final _registerInFormKey = GlobalKey<FormState>();
  late ApiService apiService;
  bool isLoading = false;

  @override
  void initState() {
    apiService = ApiService();
    super.initState();
  }

  void register() async {
    setState(() {
      isLoading = true;
    });
    final name = _usernameController.text;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final passwordAgain = _passwordAgainController.text;
    if(passwordAgain == password) {
      bool check = await apiService.register(email, name, password);
      print(check);
      setState(() {
        isLoading = false;
      });
      if(check) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                "Đăng ký",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.08,
                    color: Colors.white
                ),
              ),
            ),
            backgroundColor: MyColors.backgroundColor,
            body: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30,),
                  Form(
                    key: _registerInFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Nhập tên tài khoản...',
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
                          controller: _emailController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Nhập email...',
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
                              return 'Bạn chưa nhập email';
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
                        const SizedBox(height: 30,),
                        TextFormField(
                          controller: _passwordAgainController,
                          obscureText: _isShowPassWord,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Nhập lại mật khẩu...',
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
                              return 'Bạn chưa nhập lại mật khẩu';
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
                      if (_registerInFormKey.currentState!.validate()) {
                        register();
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
                            'Đăng ký',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        )
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 15,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
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
                            'Đã có tài khoản? Đăng nhập',
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


