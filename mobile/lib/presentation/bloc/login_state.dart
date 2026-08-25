import 'package:portfolioapp/domain/entities/login_user_entities.dart';

abstract class LoginState {}

class Initial extends LoginState {}

class Logging extends LoginState {}

class Loggedin extends LoginState {
  LoginUserEntities user;
  Loggedin(this.user);
}
