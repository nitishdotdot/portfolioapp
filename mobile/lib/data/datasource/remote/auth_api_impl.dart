import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:portfolioapp/domain/api/auth_api.dart';

class AuthApiImpl extends AuthApi {
  @override
  Future<bool> signInApi() async {
    try {
      Dio dio = Dio();
      final url = dotenv.get('BACKEND_URL');
      final response = await dio.post('$url/user', data: {''});
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
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
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
