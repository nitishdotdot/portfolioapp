import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: FooterClipper(),
      child: Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height * .1,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}

class FooterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final y = size.height;
    final x = size.width;
    final k = 1 - 0.7;
    Path path = Path();
    path.moveTo(0, y);
    path.quadraticBezierTo(0, y, 0, k * y);
    path.quadraticBezierTo(x / 4, 2 * k * y, x / 2, k * y);
    path.quadraticBezierTo(3 * x / 4, 0, x, k * y);
    path.quadraticBezierTo(x, k * y, x, y);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
