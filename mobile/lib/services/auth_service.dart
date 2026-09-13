import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:portfolioapp/domain/entities/login_user_entities.dart';

class Authservice {
  Authservice._();
  static final Authservice authservice = Authservice._();
  GoogleSignInAccount? globalUser;
  factory Authservice() => authservice;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  Future<LoginUserEntities> login() async {
    final clientId = dotenv.get('CLIENT_ID');
    final serverclientId = dotenv.get('SERVER_ID');

    await googleSignIn.initialize(
      clientId: clientId,
      serverClientId: serverclientId,
    );
    final user = await googleSignIn.authenticate();

    Dio dio = Dio();
    String backendUrl = dotenv.get('BACKEND_URL');
    await dio.post(
      '$backendUrl/user',
      data: {
        'name': user.displayName,
        'email': user.email,
        'googleId': user.id,
        'photoUrl': user.photoUrl,
      },
    );
    return LoginUserEntities(
      email: user.email,
      name: user.displayName,
      googleId: user.id,
      photoUrl: user.photoUrl,
    );
  }

  Future logout() async {
    await googleSignIn.signOut();
  }
}
