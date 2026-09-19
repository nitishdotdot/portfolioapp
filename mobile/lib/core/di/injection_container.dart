import 'package:get_it/get_it.dart';
import 'package:portfolioapp/data/datasource/local/localstorage.dart';
import 'package:portfolioapp/data/datasource/remote/auth_api_impl.dart';
import 'package:portfolioapp/data/datasource/remote/user_api_impl.dart';
import 'package:portfolioapp/data/models/user_model.dart';
import 'package:portfolioapp/data/repository/auth_repository_impl.dart';
import 'package:portfolioapp/data/repository/user_repository_impl.dart';
import 'package:portfolioapp/domain/api/auth_api.dart';
import 'package:portfolioapp/domain/api/user_api.dart';
import 'package:portfolioapp/domain/repository/auth_repository.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';

final s1 = GetIt.instance;
void init() {
  s1.registerLazySingleton<AuthApi>(() => AuthApiImpl());
  s1.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(s1<AuthApi>()),
  );
  s1.registerLazySingleton<Localstorage>(() => Localstorage());
  s1.registerLazySingleton<UserApi>(() => UserApiImpl());
  s1.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(s1<UserApi>()),
  );
}
