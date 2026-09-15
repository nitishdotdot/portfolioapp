import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:portfolioapp/domain/api/auth_api.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthApiImpl extends AuthApi {
  // AuthApiImpl._();
  // static final AuthApiImpl _authApi = AuthApiImpl._();
  // factory AuthApiImpl() => _authApi;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  @override
  Future<bool> signInApi(String email, String password) async {
    try {
      Dio dio = Dio();
      final url = dotenv.get('BACKEND_URL');
      final response = await dio.post(
        '$url/signin',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        return true;
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> googleSigninApi() async {
    try {
      final clientId = dotenv.get('CLIENT_ID');
      final serverclientId = dotenv.get('SERVER_ID');

      await googleSignIn.initialize(
        clientId: clientId,
        serverClientId: serverclientId,
      );
      final user = await googleSignIn.authenticate();
      Dio dio = Dio();
      String backendUrl = dotenv.get('BACKEND_URL');
      final response = await dio.post(
        '$backendUrl/googlesignin',
        data: {
          'name': user.displayName,
          'email': user.email,
          'googleId': user.id,
          'photoUrl': user.photoUrl,
          'idToken': user.authentication.idToken,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('error encountered in catch $e');
      return false;
    }
  }

  @override
  Future<void> googleSignoutApi() async {
    await googleSignIn.signOut();
  }
}
