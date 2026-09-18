import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:portfolioapp/data/datasource/local/localstorage.dart';
import 'package:portfolioapp/domain/api/user_api.dart';
import 'package:portfolioapp/core/di/injection_container.dart';

class UserApiImpl extends UserApi {
  @override
  Future<void> userDataApi() async {
    Dio dio = Dio();
    final localstorage = s1<Localstorage>();
    String? token = await localstorage.getToken();
    final response = await dio.get(
      '${dotenv.get('BACKEND_URL')}/user',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
