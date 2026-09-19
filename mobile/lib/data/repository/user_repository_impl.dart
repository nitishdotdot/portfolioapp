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
}
