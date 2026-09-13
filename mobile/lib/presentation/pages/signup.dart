import 'package:flutter/material.dart';
import 'package:portfolioapp/presentation/widget/header.dart';
import 'package:portfolioapp/presentation/widget/footer.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController? name;
  TextEditingController? email;
  TextEditingController? password;
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
                    TextField(controller: name),
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
