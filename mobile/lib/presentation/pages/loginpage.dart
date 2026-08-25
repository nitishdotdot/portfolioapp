import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolioapp/presentation/bloc/login_bloc.dart';
import 'package:portfolioapp/presentation/bloc/login_event.dart';
import 'package:portfolioapp/presentation/bloc/login_state.dart';
import 'package:portfolioapp/presentation/pages/portfolioapp.dart';
import 'package:portfolioapp/presentation/widget/footer.dart';
import 'package:portfolioapp/presentation/widget/header.dart';

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
              builder: (_) => AlertDialog(content: CircularProgressIndicator()),
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
                              onPressed: () => {},
                              child: Icon(Icons.forward),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(24),
                              ),
                            ),
                            SizedBox(height: 15),
                            FloatingActionButton(
                              onPressed: () {
                                context.read<LoginBloc>().add(DoLogin());
                              },
                              child: Image.asset('assets/google.png'),
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
