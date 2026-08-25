import 'package:portfolioapp/domain/entities/user_entities.dart';

abstract class Userstate {}

class Initial extends Userstate {}

class UserLoading extends Userstate {}

class UserLoaded extends Userstate {
  List<UserEntities> data;
  UserLoaded(this.data);
}
