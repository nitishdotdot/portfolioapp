import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:portfolioapp/data/datasource/local/localstorage.dart';
import 'package:portfolioapp/data/models/user_model.dart';
import 'package:portfolioapp/domain/api/user_api.dart';
import 'package:portfolioapp/core/di/injection_container.dart';

class UserApiImpl extends UserApi {
  Dio dio = Dio();
  @override
  Future<UserModel> userDataApi() async {
    final localstorage = s1<Localstorage>();
    String? token = await localstorage.getToken();
    final response = await dio.get(
      '${dotenv.get('BACKEND_URL')}/user',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print(response.data);
    final userModel = UserModel.fromJson(response.data);
    return userModel;
  }

  @override
  Future<bool> deleteaUserData() async {
    final localstorage = s1<Localstorage>();
    String? token = await localstorage.getToken();
    try {
      final response = await dio.delete(
        '${dotenv.get('BACKEND_URL')}/deleteuser',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> addUserApi(
    String name,
    int kitta,
    int buyprice,
    String buydatetime,
  ) async {
    final localstorage = s1<Localstorage>();
    String? token = await localstorage.getToken();
    try {
      final response = await dio.post(
        '${dotenv.get('BACKEND_URL')}/buyscrip',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          "name": name,
          "kitta": kitta,
          "buyprice": buyprice,
          "buydatetime": buydatetime,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
