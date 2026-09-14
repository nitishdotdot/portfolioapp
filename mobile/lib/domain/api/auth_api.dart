abstract class AuthApi {
  Future<bool> signInApi();
  Future<bool> signUpApi(String name, String email, String password);
}
