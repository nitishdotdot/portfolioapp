import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolioapp/presentation/bloc/login_event.dart';
import 'package:portfolioapp/presentation/bloc/login_state.dart';
import 'package:portfolioapp/services/auth_service.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final auth = Authservice();
  LoginBloc() : super(Initial()) {
    on<DoLogin>((event, emit) {
      emit(Logging());
      final auth = Authservice();
      final user = auth.login();
      if (user != null) {
        emit(Loggedin(user));
      }
    });
    on<DoLogout>((event, emit) {
      final auth = Authservice();
      auth.logout();
      emit(Initial());
    });
  }
}
