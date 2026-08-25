import 'package:dio/dio.dart';
import 'package:portfolioapp/data/models/serviceresponce.dart';
import 'package:portfolioapp/domain/entities/user_entities.dart';
import 'package:portfolioapp/domain/repository/user_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserApiImpl implements UserApi {
  @override
  Future<Serviceresponce<List<UserEntities>>> getusers() async {
    final dio = Dio();
    String path = dotenv.get('BACKEND_URL');
    final String path1 = '$path/user';
    print(path1);
    final responce = await dio.get(path1);
    print('dio responce is ');
    print(responce);
    final user = (responce.data as List)
        .map((x) => UserEntities.fromjson(x))
        .toList();
    print(user);
    return Serviceresponce(user: user, statuscode: 200, message: "ok");
  }
}
