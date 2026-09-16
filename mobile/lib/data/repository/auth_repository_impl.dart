import 'package:portfolioapp/domain/api/auth_api.dart';
import 'package:portfolioapp/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthApi authApi;
  AuthRepositoryImpl(this.authApi);
  @override
  Future<bool> signIn(String email, String password) async {
    return await authApi.signInApi(email, password);
  }

  @override
  Future<bool> signUp(String name, String email, String password) async {
    return await authApi.signUpApi(name, email, password);
  }

  @override
  Future<bool> googleSignin() async {
    return await authApi.googleSigninApi();
  }

  @override
  Future<void> googleSignOut() async {
    await authApi.googleSignoutApi();
  }
}
