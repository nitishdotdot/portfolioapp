import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolioapp/data/datasource/remote/auth_api_impl.dart';
import 'package:portfolioapp/data/repository/auth_repository_impl.dart';
import 'package:portfolioapp/domain/api/auth_api.dart';
import 'package:portfolioapp/domain/repository/auth_repository.dart';
import 'package:portfolioapp/presentation/bloc/login_bloc.dart';
import 'package:portfolioapp/presentation/bloc/login_event.dart';
import 'package:portfolioapp/presentation/bloc/login_state.dart';
import 'package:portfolioapp/presentation/pages/portfolioapp.dart';
import 'package:portfolioapp/presentation/pages/signup.dart';
import 'package:portfolioapp/presentation/widget/footer.dart';
import 'package:portfolioapp/presentation/widget/header.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isobscured = true;
  bool eyeiconcrossed = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is Loggedin) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Portfolioapp()),
            );
          } else if (state is Logging) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LoadingAnimationWidget.flickr(
                  leftDotColor: Colors.red,
                  rightDotColor: Colors.blueGrey,
                  size: 40,
                );
              },
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              children: [
                SizedBox(child: Header()),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'LOGIN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(height: 24),
                            TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromARGB(0, 64, 54, 54),
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: password,
                              obscureText: isobscured,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: eyeiconcrossed
                                    ? IconButton(
                                        onPressed: () => {
                                          setState(() {
                                            isobscured = !isobscured;
                                            eyeiconcrossed = !eyeiconcrossed;
                                          }),
                                        },
                                        icon: Icon(Icons.visibility_off),
                                      )
                                    : IconButton(
                                        onPressed: () => {
                                          setState(() {
                                            isobscured = !isobscured;
                                            eyeiconcrossed = !eyeiconcrossed;
                                          }),
                                        },
                                        icon: Icon(Icons.visibility),
                                      ),
                                labelText: 'password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            FloatingActionButton(
                              onPressed: () async {
                                AuthApi authApi = AuthApiImpl();
                                final isValidated = await authApi.signInApi(
                                  email.text,
                                  password.text,
                                );
                                if (context.mounted) {
                                  if (isValidated) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Portfolioapp(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('wrong credentials'),
                                      ),
                                    );
                                  }
                                }
                              },

                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(24),
                              ),
                              child: Icon(Icons.forward),
                            ),
                            SizedBox(height: 15),
                            FloatingActionButton(
                              onPressed: () async {
                                // context.read<LoginBloc>().add(DoLogin());
                                AuthRepository authRepository =
                                    AuthRepositoryImpl();
                                final response = await authRepository
                                    .googleSignin();
                                if (context.mounted) {
                                  if (response == true) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => Portfolioapp(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'error in google sign in',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Image.asset('assets/google.png'),
                            ),
                            SizedBox(height: 15),
                            Divider(thickness: 2),
                            SizedBox(height: 15),

                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => Signup()),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'dont have an account ',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: 'signup',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(child: Footer()),
              ],
            ),
          );
        },
      ),
    );
  }
}
