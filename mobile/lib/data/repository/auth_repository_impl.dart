import 'package:portfolioapp/data/datasource/remote/auth_api_impl.dart';
import 'package:portfolioapp/domain/api/auth_api.dart';
import 'package:portfolioapp/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<bool> signIn(String email, String password) async {
    AuthApi authapi = AuthApiImpl();
    return await authapi.signInApi(email, password);
  }

  @override
  Future<bool> signUp(String name, String email, String password) async {
    AuthApi authapi = AuthApiImpl();
    return await authapi.signUpApi(name, email, password);
  }
}
