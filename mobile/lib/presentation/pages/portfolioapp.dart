import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolioapp/presentation/bloc/login_bloc.dart';
import 'package:portfolioapp/presentation/bloc/login_event.dart';
import 'package:portfolioapp/presentation/bloc/login_state.dart';
import 'package:portfolioapp/presentation/pages/loginpage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Portfolioapp extends StatefulWidget {
  const Portfolioapp({super.key});

  @override
  State<Portfolioapp> createState() => _PortfolioappState();
}

class _PortfolioappState extends State<Portfolioapp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WELCOME')),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(10, 40, 0, 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            content: Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Are you sure'),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text('ok'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.logout),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Image.network(),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ),
                  ],
                ),
                Divider(thickness: 2),
                Align(alignment: Alignment.topLeft, child: Text('Seetings')),
                ListTile(leading: Icon(Icons.person), title: Text('profile')),
                ListTile(leading: Icon(Icons.settings), title: Text('setting')),
                Divider(thickness: 2),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('My Portfolio'),
                ),
                ListTile(
                  leading: Icon(Icons.monetization_on),
                  title: Text('My Shares'),
                ),
                ListTile(leading: Icon(Icons.history), title: Text('History')),
                Divider(thickness: 2),
                Align(alignment: Alignment.topLeft, child: Text('About ')),
                ListTile(
                  leading: Icon(Icons.question_mark_sharp),
                  title: Text('Faqs'),
                ),
                ListTile(
                  leading: Icon(Icons.phone_android),
                  title: Text('About'),
                ),
                ListTile(leading: Icon(Icons.android), title: Text('Version')),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(child: Column(children: [
                  ],
                )),
            ),
          ],
        ),
      ),
    );
  }
}
