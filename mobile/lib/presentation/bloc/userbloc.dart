import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolioapp/data/repository/user_repository_impl.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';
import 'package:portfolioapp/presentation/bloc/userevent.dart';
import 'package:portfolioapp/presentation/bloc/userstate.dart';

class UserBloc extends Bloc<Userevent, Userstate> {
  UserRepository userRepository = UserRepositoryImpl();
  UserBloc() : super(Initial()) {
    on<GetUserEvent>((event, emit) async {
      emit(UserLoading());
      final responce = await userRepository.getusers(); 
      emit(UserLoaded(responce));
    });
  }
}
