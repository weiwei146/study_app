import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_app/model/User.dart';

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

  Future<List<Vocabulary>> getWordByLessonId(String lessonTitle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    try {
      final response = await dio.get(
        '/learn/get-words/$lessonTitle',
      );
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => Vocabulary.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi khi tải danh sách bài học');
      }
    } catch (e) {
      print('Lỗi: $e');
      return [];
    }
  }

  Future<void> maskWordOnLesson(String wordID, String lessonTitle, String level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    try {
      Response response;
      response = await dio.post(
          '/learn/word-learned',
          data: {
            "wordId": wordID,
            "lessonTitle": lessonTitle,
            "isLearned": true,
            "level": level
          }
      );
      if (response.statusCode == 201) {
        var message = response.data['message'];
        if(message == "Word progress updated.") {
          //print(message);
        }
      } else {
        print('Lỗi cập nhật: ${response.statusMessage}');
      }
    } catch(e) {
      print('Lỗi kết nối: $e');
    }
  }

  Future<void> maskLesson(String lessonID, int lessNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    print(prefs.getString('token'));
    print(lessonID);
    print(lessNumber);
    try {
      Response response;
      response = await dio.post(
          '/learn/lesson-completed/$lessonID/$lessNumber',
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        print("Update hoan thanh bai hoc");
      } else {
        print('Lỗi cập nhật: ${response.statusMessage}');
      }
    } catch(e) {
      print('Lỗi kết nối mask lesson: $e');
    }
  }

  Future<void> startLesson(String lessonID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    print(prefs.getString('token'));
    print(lessonID);
    try {
      Response response;
      response = await dio.post(
        '/learn/start-lesson',
        data: {
          'lessonId': lessonID
        }
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        print("Update gia trinh hoc bai");
      } else {
        print('Lỗi cập nhật: ${response.statusMessage}');
      }
    } catch(e) {
      print('Lỗi kết nối start lesson: $e');
    }
  }

  Future<void> startLearning(String lessonID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    print(prefs.getString('token'));
    print(lessonID);
    try {
      Response response;
      response = await dio.post(
          '/learn/start',
          data: {
            'lessonId': lessonID
          }
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        print("Update gia trinh hoc bai");
      } else {
        print('Lỗi cập nhật: ${response.statusMessage}');
      }
    } catch(e) {
      print('Lỗi kết nối start learning: $e');
    }
  }

  Future<User> getInformationUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';

    try {
      final response = await dio.get(
          '/profile/user-info'
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final user = User.fromJson(data);

        return user;
      } else {
        throw Exception('Lỗi khi tải thông tin người dùng');
      }
    } catch (e) {
      print('Lỗi: $e');
      rethrow;
    }
  }
}