abstract class AuthApi {
  Future<bool> signInApi(String email, String password);
  Future<bool> signUpApi(String name, String email, String password);
  Future<bool> googleSigninApi();
  Future<void> googleSignoutApi();
}
