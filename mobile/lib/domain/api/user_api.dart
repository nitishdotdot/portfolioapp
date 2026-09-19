import 'package:portfolioapp/data/models/user_model.dart';

abstract class UserApi {
  Future<UserModel> userDataApi();
}
