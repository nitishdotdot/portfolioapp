import 'package:portfolioapp/data/datasource/remote/auth_api_impl.dart';
import 'package:portfolioapp/domain/api/auth_api.dart';
import 'package:portfolioapp/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<bool> signIn() async {
    AuthApi authapi = AuthApiImpl();
    return await authapi.signInApi();
  }

  @override
  Future<bool> signUp(String name, String email, String password) async {
    AuthApi authapi = AuthApiImpl();
    return await authapi.signUpApi();
  }
}
