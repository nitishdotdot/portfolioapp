import 'package:portfolioapp/data/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> userData();
}
