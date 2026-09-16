import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolioapp/presentation/bloc/login_event.dart';
import 'package:portfolioapp/presentation/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(Initial()) {
    on<DoLogin>((event, emit) async {
      emit(Logging());

      //  emit(Loggedin(user));
    });
    on<DoLogout>((event, emit) async {
      emit(SigningOut());

      emit(Initial());
    });
  }
}
