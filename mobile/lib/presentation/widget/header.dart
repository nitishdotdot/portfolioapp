import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        color: Colors.green,
        height: MediaQuery.of(context).size.height * .1,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final x = size.width;
    final y = size.height;
    final k = .7;
    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 0, 0, k * y);
    path.quadraticBezierTo(x / 4, y, x / 2, k * y);
    path.quadraticBezierTo(3 * x / 4, 2 * k * y - y, x, k * y);
    path.quadraticBezierTo(x, k * y, x, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
