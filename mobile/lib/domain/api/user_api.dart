import 'package:portfolioapp/data/models/alluser_model.dart';
import 'package:portfolioapp/data/models/user_model.dart';

abstract class UserApi {
  Future<UserModel> userDataApi();
  Future<bool> deleteaUserApi();
  Future<bool> addUserApi(String name, int kitta, int buyprice, String buytime);

  Future<bool> sellUserApi(
    String name,
    int kitta,
    int buyprice,
    String buytime,
  );
  Future<List<AlluserModel>> getallUserApi();
}
