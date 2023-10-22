import 'package:flutter/material.dart';

class ProfilePageBackground extends StatelessWidget {
  final screenHeight;
  final String imageUrl;
  const ProfilePageBackground(
      {super.key, this.screenHeight, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipPath(
        clipper: BottomShapeClipper(),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  opacity: 0.3,
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover)),
          height: screenHeight * 0.3,
        ),
      ),
    ]);
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
