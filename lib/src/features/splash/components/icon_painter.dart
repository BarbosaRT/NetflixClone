import 'package:flutter/material.dart';

class IconPainter extends CustomPainter {
  final Path path;
  final Color color;

  const IconPainter({required this.path, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool hitTest(Offset position) => path.contains(position);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
