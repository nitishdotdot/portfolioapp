import 'package:portfolioapp/domain/api/user_api.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  UserApi userApi;
  UserRepositoryImpl(this.userApi);
  @override
  Future<void> userData() async {
    await userApi.userDataApi();
  }
}
