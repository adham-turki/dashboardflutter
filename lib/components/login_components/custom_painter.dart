import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  BuildContext context;
  MyPainter({
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(-1 * (width * 0.18), 0)
      ..lineTo(width * 0.118, 0)
      ..lineTo(width * 0.118, height)
      ..lineTo(-1 * (width * 0.36), height)
      ..close();

    // Draw the shadow
    final shadowPaint = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0)
      ..maskFilter =
          const MaskFilter.blur(BlurStyle.inner, 120); // Adjust the blur radius

    canvas.drawPath(path, shadowPaint);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
