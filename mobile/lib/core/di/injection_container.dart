import 'package:get_it/get_it.dart';
import 'package:portfolioapp/data/datasource/remote/auth_api_impl.dart';
import 'package:portfolioapp/data/repository/auth_repository_impl.dart';
import 'package:portfolioapp/domain/api/auth_api.dart';
import 'package:portfolioapp/domain/repository/auth_repository.dart';

final s1 = GetIt.instance;
void init() {
  s1.registerLazySingleton<AuthApi>(() => AuthApiImpl());
  s1.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(s1<AuthApi>()),
  );
}
