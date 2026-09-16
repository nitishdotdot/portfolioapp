import 'package:flutter/material.dart';
import 'package:portfolioapp/core/di/injection_container.dart';
import 'package:portfolioapp/data/repository/auth_repository_impl.dart';
import 'package:portfolioapp/domain/repository/auth_repository.dart';
import 'package:portfolioapp/presentation/pages/loginpage.dart';
import 'package:portfolioapp/presentation/pages/portfolioapp.dart';
import 'package:portfolioapp/presentation/widget/header.dart';
import 'package:portfolioapp/presentation/widget/footer.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isobsured = true;
  String? name1;
  String? email1;
  String? password1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(child: Header()),
            Expanded(
              child: Padding(
                padding: EdgeInsetsGeometry.fromLTRB(10, 0, 10, 10),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'SIGNUP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: name,
                          decoration: InputDecoration(
                            labelText: 'name...',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: email,

                          decoration: InputDecoration(
                            labelText: 'email...',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          obscureText: isobsured,
                          controller: password,
                          decoration: InputDecoration(
                            labelText: 'password...',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isobsured = !isobsured;
                                });
                              },
                              icon: isobsured
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            ),
                            prefixIcon: Icon(Icons.password),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            final authRepository = s1<AuthRepository>();
                            final response = await authRepository.signUp(
                              name.text,
                              email.text,
                              password.text,
                            );
                            if (context.mounted) {
                              if (response == true) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Loginpage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('error in signup')),
                                );
                              }
                            }
                          },
                          child: Text('ok'),
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
      ),
    );
  }
}
