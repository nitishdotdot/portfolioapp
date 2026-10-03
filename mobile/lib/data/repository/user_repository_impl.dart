import 'package:portfolioapp/data/models/alluser_model.dart';
import 'package:portfolioapp/data/models/user_model.dart';
import 'package:portfolioapp/domain/api/user_api.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  UserApi userApi;
  UserRepositoryImpl(this.userApi);
  @override
  Future<UserModel> userData() async {
    return await userApi.userDataApi();
  }

  @override
  Future<bool> deleteuser() async {
    return userApi.deleteaUserApi();
  }

  @override
  Future<bool> addUser(
    String name,
    int kitta,
    int buyprice,
    String buydatetime,
  ) async {
    return await userApi.addUserApi(name, kitta, buyprice, buydatetime);
  }

  @override
  Future<List<AlluserModel>> getallUser() async {
    return await userApi.getallUserApi();
  }

  @override
  Future<bool> sellUser(
    String name,
    int kitta,
    int buyprice,
    String buydatetime,
  ) {
    return userApi.sellUserApi(name, kitta, buyprice, buydatetime);
  }
}
