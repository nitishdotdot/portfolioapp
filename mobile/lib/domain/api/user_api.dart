import 'package:portfolioapp/data/models/user_model.dart';

abstract class UserApi {
  Future<UserModel> userDataApi();
  Future<bool> deleteaUserData();
  Future<bool> addUserApi(String name, int kitta, int buyprice, String buytime);
}
