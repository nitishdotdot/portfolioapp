import 'package:portfolioapp/data/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> userData();
  Future<bool> deleteUserData();
  Future<bool> addUser(
    String name,
    int kitta,
    int buyprice,
    String buydatetime,
  );
}
