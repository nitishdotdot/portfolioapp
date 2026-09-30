import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:portfolioapp/presentation/pages/portfolioapp.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          onPressed: () => {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Portfolioapp()),
            ),
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(child: Column(children: [ListTile()])),
    );
  }
}
