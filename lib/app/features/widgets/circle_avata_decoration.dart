import 'dart:math';

import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class CircleAvatarDecoration extends StatelessWidget {
  const CircleAvatarDecoration({super.key, this.child, this.onTap, this.diameter = 48, this.strokeWidth = 4});

  final Widget? child;
  final double diameter;
  final VoidCallback? onTap;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: diameter,
        child: CustomPaint(
          painter: _ProfileProgressIndicatorPainter(
            color: context.themes.main.colors.secondary.withAlpha(150),
            strokeWidth: strokeWidth,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

final class _ProfileProgressIndicatorPainter extends CustomPainter {
  const _ProfileProgressIndicatorPainter({this.color = Colors.grey, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.height, height: size.width),
      0.0,
      pi * 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
