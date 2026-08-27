import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolioapp/presentation/bloc/login_event.dart';
import 'package:portfolioapp/presentation/bloc/login_state.dart';
import 'package:portfolioapp/services/auth_service.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final auth = Authservice();
  LoginBloc() : super(Initial()) {
    on<DoLogin>((event, emit) async {
      emit(Logging());
      final auth = Authservice();
      final user = await auth.login();
      emit(Loggedin(user));
    });
    on<DoLogout>((event, emit) async {
      emit(SigningOut());
      final auth = Authservice();
      await auth.logout();
      emit(Initial());
    });
  }
}
