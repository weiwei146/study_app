import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Lesson.dart';
import '../model/Vocabulary.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? '',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<bool> login(String email, String password) async {
    try {
      Response response;
      response = await dio.post(
          '/auth/login',
          data: {
            'email': email,
            'password': password
          }
      );
      if (response.statusCode == 201) {
        var token = response.data['token'];
        var user = response.data['user'];

        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('token', token);
        prefs.setString('user_email', user['email']);
        prefs.setString('user_name', user['name']);
        prefs.setString('user_level', user['level']);
        prefs.setBool('user_isLevelAssessed', user['isLevelAssessed']);
        prefs.setBool('user_isLearningStarted', user['isLearningStarted']);

        print(prefs.getKeys());
        for (String key in prefs.getKeys()) {
          print('$key: ${prefs.get(key)}');
        }

        return true;
      } else {
        print('Lỗi đăng nhập: ${response.statusMessage}');
        return false;
      }
    } catch(e) {
      print('Lỗi kết nối: $e');
      return false;
    }
  }

  Future<bool> register(String email, String name, String password) async {
    try {
      Response response;
      response = await dio.post(
          '/auth/register',
          data: {
            'email': email,
            'password': password,
            'name': name
          }
      );
      if (response.statusCode == 201) {
        var message = response.data['message'];
        if(message == "User successfully registered") return true;
        return false;
      } else {
        print('Lỗi đăng ký: ${response.statusMessage}');
        return false;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        print('Có người dùng email này rồi');
      } else {
        print('Lỗi máy chủ');
      }
      return false;
    } catch(e) {
      print('Lỗi kết nối: $e');
      return false;
    }
  }

  Future<List<Lesson>> getLessons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    try {
      final response = await dio.get(
          '/learn/get-lessons',
      );
      if (response.statusCode == 200) {
        final data = response.data as List;

        return data.map((json) => Lesson.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi khi tải danh sách bài học');
      }
    } catch (e) {
      print('Lỗi: $e');
      return [];
    }
  }

  Future<List<Vocabulary>> getWordByLessonId(String lessonId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    try {
      final response = await dio.get(
        '/learn/get-words/$lessonId',
      );
      print(response.statusCode);
      print(lessonId);
      if (response.statusCode == 200) {
        final data = response.data as List;
        print(data);
        return data.map((json) => Vocabulary.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi khi tải danh sách bài học');
      }
    } catch (e) {
      print('Lỗi: $e');
      return [];
    }
  }
}