import 'package:flutter/material.dart';

enum TriangleDirection { up, down, left, right }

class RoundedTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final paint = Paint()
      ..color = const Color.fromARGB(255, 19, 46, 59)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo((width / 2) - 16, 80)
      ..arcToPoint(
        Offset((width / 2) + 20, 80),
        radius: Radius.circular(22),
        clockwise: true,
      )
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}