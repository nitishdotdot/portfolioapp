import 'package:portfolioapp/domain/entities/user_entities.dart';

abstract class UserRepository {
  Future<List<UserEntities>> getusers();
}
