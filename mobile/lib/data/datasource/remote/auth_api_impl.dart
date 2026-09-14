import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:portfolioapp/domain/api/auth_api.dart';

class AuthApiImpl extends AuthApi {
  @override
  Future<bool> signInApi(String email, String password) async {
    try {
      Dio dio = Dio();
      final url = dotenv.get('BACKEND_URL');
      print('----------');
      print('$email  $password');
      final response = await dio.post(
        '$url/signin',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        print('-------------------------');
        print(response);
        if (response.data == "ok") {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signUpApi(String name, String email, String password) async {
    try {
      Dio dio = Dio();
      final url = dotenv.get('BACKEND_URL');
      final response = await dio.post(
        '$url/signup',
        data: {'name': name, 'email': email, 'password': password},
        options: Options(),
      );
      if (response.statusCode == 200) {
        debugPrint(response.statusMessage);
        return true;
      } else {
        debugPrint(response.statusMessage);
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
