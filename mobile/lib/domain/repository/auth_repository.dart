abstract class AuthRepository {
  Future<bool> signIn();
  Future<bool> signUp(String name, String email, String password);
}
