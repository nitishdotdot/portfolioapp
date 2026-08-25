import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:portfolioapp/presentation/bloc/userstate.dart';
import 'package:portfolioapp/presentation/pages/loginpage.dart';
import 'dart:async';
import 'package:portfolioapp/main.dart';
import 'package:flutter/material.dart';
import 'package:portfolioapp/domain/entities/login_user_entities.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Authservice {
  Authservice._();
  static final Authservice authservice = Authservice._();
  GoogleSignInAccount? globalUser;
  factory Authservice() => authservice;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  LoginUserEntities login() {
    final clientId = dotenv.get('CLIENT_ID');
    final serverclientId = dotenv.get('SERVER_ID');
    unawaited(
      googleSignIn
          .initialize(clientId: clientId, serverClientId: serverclientId)
          .then((_) {
            googleSignIn.authenticationEvents.listen(_ondata).onError(_onerror);
            googleSignIn.attemptLightweightAuthentication();
          }),
    );
    return LoginUserEntities(
      email: globalUser!.email,
      name: globalUser!.displayName!,
      googleId: globalUser!.id,
      photoUrl: globalUser!.photoUrl!,
    );
  }

  void _onerror(Object e, StackTrace s) {}

  void _ondata(GoogleSignInAuthenticationEvent event) async {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      GoogleSignInAccount user = event.user;
      Dio dio = Dio();
      final res = await dio.post(
        'http://192.168.18.7:3000/user',
        data: {
          'name': user.displayName,
          'email': user.email,
          'googleId': user.id,
          'photoUrl': user.photoUrl,
        },
      );
      if (res.statusCode == 200) {
        globalUser = user;
      }
    }
  }

  void logout() async {
    await googleSignIn.signOut();
  }
}
