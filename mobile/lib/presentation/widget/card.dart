import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyCard extends StatefulWidget {
  final Widget child;
  final Color? color;
  const MyCard({super.key, required this.child, this.color});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: (widget.color != null)
          ? widget.color!.withAlpha(50)
          : Colors.red.withAlpha(50),
      elevation: 5,
      shadowColor: Colors.black,
      child: widget.child,
    );
  }
}
