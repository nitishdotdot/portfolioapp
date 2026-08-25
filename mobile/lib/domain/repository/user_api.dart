import 'package:portfolioapp/data/models/serviceresponce.dart';
import 'package:portfolioapp/domain/entities/user_entities.dart';

abstract class UserApi {
  Future<Serviceresponce<List<UserEntities>>> getusers();
}
