import 'package:portfolioapp/data/repository/user_api_impl.dart';
import 'package:portfolioapp/domain/repository/user_api.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';
import 'package:portfolioapp/domain/entities/user_entities.dart';

class UserRepositoryImpl implements UserRepository {
  UserApi userApi = UserApiImpl();
  @override
  Future<List<UserEntities>> getusers() async {
    final responce = await userApi.getusers();
    return responce.user;
  }
}
