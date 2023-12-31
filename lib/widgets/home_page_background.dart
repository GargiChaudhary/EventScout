import 'package:flutter/material.dart';

class HomePageBackground extends StatelessWidget {
  final screenHeight;
  const HomePageBackground({super.key, this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomShapeClipper(),
      child: Container(
        height: screenHeight * 0.55,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class BottomShapeClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    Offset curveStartPoint = Offset(0, size.height * 0.75);
    Offset curveEndPoint = Offset(size.width, size.height * 0.75);
    path.lineTo(curveStartPoint.dx, curveStartPoint.dy);
    path.quadraticBezierTo(
        size.width / 2, size.height, curveEndPoint.dx, curveEndPoint.dy);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
