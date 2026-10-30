import 'package:flutter/material.dart';
import 'package:portfolioapp/presentation/pages/portfolioapp.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Version extends StatefulWidget {
  const Version({super.key});

  @override
  State<Version> createState() => _VersionState();
}

String version = "";

class _VersionState extends State<Version> {
  Future<void> getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Portfolioapp()),
            );
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text('version'),
      ),
      body: Column(children: [Text(version)]),
    );
  }
}
