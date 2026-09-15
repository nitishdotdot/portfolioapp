abstract class AuthRepository {
  Future<bool> signIn(String email, String password);
  Future<bool> signUp(String name, String email, String password);
  Future<bool> googleSignin();
  Future<void> googleSignOut();
}
