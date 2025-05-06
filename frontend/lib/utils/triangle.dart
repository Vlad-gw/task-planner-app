import 'package:flutter/material.dart';
import 'dart:math';

class TrianglePainter extends CustomPainter {
  const TrianglePainter({required this.cornerRadius});
  final double cornerRadius;
  final count = 3;

  @override
void paint(Canvas canvas, Size size) {
  canvas.translate(size.width / 2, size.height / 2);

  final path = Path();
  final List<Offset> points = [];

  final h = 2 * size.width / 2 * sin(pi / count);
  final max = h * sqrt(3) / 6;
  final radius = cornerRadius > max ? max : cornerRadius;
  final offset = -pi / 2;

  for (int i = 0; i < count; i++) {
    final perRad = 2 * pi / count * i;
    final point = Offset(
      size.width / 2 * cos(perRad + offset),
      size.width / 2 * sin(perRad + offset),
    );
    points.add(point);

    final diffX = radius / 2 * sqrt(3);
    final diffY = radius * 2 - radius / 2;

    switch (i) {
      case 0:
        path.moveTo(point.dx - diffX, point.dy + diffY);
        path.arcToPoint(
          Offset(point.dx + diffX, point.dy + diffY),
          radius: Radius.circular(radius),
          largeArc: false,
        );
        break;
      case 1:
        path.lineTo(point.dx - diffX, point.dy - diffY);
        path.arcToPoint(
          Offset(point.dx - (diffX * 2), point.dy),
          radius: Radius.circular(radius),
          largeArc: false,
        );
        break;
      case 2:
        path.lineTo(point.dx + (diffX * 2), point.dy);
        path.arcToPoint(
          Offset(point.dx + diffX, point.dy - diffY),
          radius: Radius.circular(radius),
          largeArc: false,
        );
        path.close();
        break;
    }
  }
  canvas.drawPath(
    path,
    Paint()
      ..color = Color.fromARGB(255, 154, 160, 166),
  );
}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}