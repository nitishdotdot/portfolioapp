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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('SIGNUP'),
                    TextFormField(
                      controller: name,
                      decoration: InputDecoration(),
                    ),
                    TextFormField(controller: email),
                    TextFormField(controller: password),
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
                              MaterialPageRoute(builder: (_) => Loginpage()),
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
            SizedBox(child: Footer()),
          ],
        ),
      ),
    );
  }
}
