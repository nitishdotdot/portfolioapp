import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyCard extends StatefulWidget {
  final Widget child;
  const MyCard({super.key, required this.child});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.withAlpha(50),
      elevation: 10,
      shadowColor: Colors.black,
      child: widget.child,
    );
  }
}
