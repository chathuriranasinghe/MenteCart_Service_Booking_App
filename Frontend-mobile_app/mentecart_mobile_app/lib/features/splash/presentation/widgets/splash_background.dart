import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 0,
            right: 0,
            bottom: 38,
            child: _BottomCityIllustration(),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _BottomCityIllustration extends StatelessWidget {
  const _BottomCityIllustration();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width, 190),
        painter: _BottomCityPainter(),
      ),
    );
  }
}

class _BottomCityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final outlinePaint = Paint()
      ..color = Colors.white.withAlpha(32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final detailPaint = Paint()
      ..color = Colors.white.withAlpha(24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final groundPaint = Paint()
      ..color = Colors.white.withAlpha(18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final w = size.width;
    final h = size.height;

    final groundY = h - 18;

    canvas.drawLine(Offset(0, groundY), Offset(w, groundY), groundPaint);

    _drawLeftBuilding(canvas, outlinePaint, detailPaint, 22, groundY);
    _drawSmallBuilding(canvas, outlinePaint, detailPaint, 70, groundY + 2);
    _drawHouse(canvas, outlinePaint, detailPaint, 105, groundY);
    _drawCenterHouse(canvas, outlinePaint, detailPaint, w * 0.52, groundY);
    _drawTallBuilding(canvas, outlinePaint, detailPaint, w - 122, groundY);
    _drawRightHouse(canvas, outlinePaint, detailPaint, w - 70, groundY + 1);
  }

  void _drawLeftBuilding(
    Canvas canvas,
    Paint outlinePaint,
    Paint detailPaint,
    double x,
    double groundY,
  ) {
    final path = Path()
      ..moveTo(x, groundY)
      ..lineTo(x, groundY - 82)
      ..lineTo(x + 34, groundY - 92)
      ..lineTo(x + 68, groundY - 82)
      ..lineTo(x + 68, groundY)
      ..close();

    canvas.drawPath(path, outlinePaint);

    for (double row = groundY - 70; row < groundY - 18; row += 17) {
      for (double col = x + 10; col < x + 55; col += 18) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(col, row, 8, 9),
            const Radius.circular(1.5),
          ),
          detailPaint,
        );
      }
    }
  }

  void _drawSmallBuilding(
    Canvas canvas,
    Paint outlinePaint,
    Paint detailPaint,
    double x,
    double groundY,
  ) {
    final path = Path()
      ..moveTo(x, groundY)
      ..lineTo(x, groundY - 58)
      ..lineTo(x + 38, groundY - 68)
      ..lineTo(x + 76, groundY - 58)
      ..lineTo(x + 76, groundY)
      ..close();

    canvas.drawPath(path, outlinePaint);

    for (double row = groundY - 45; row < groundY - 15; row += 15) {
      for (double col = x + 12; col < x + 62; col += 18) {
        canvas.drawRect(Rect.fromLTWH(col, row, 8, 8), detailPaint);
      }
    }
  }

  void _drawHouse(
    Canvas canvas,
    Paint outlinePaint,
    Paint detailPaint,
    double x,
    double groundY,
  ) {
    final roof = Path()
      ..moveTo(x, groundY - 42)
      ..lineTo(x + 42, groundY - 80)
      ..lineTo(x + 84, groundY - 42);

    final body = Path()
      ..moveTo(x + 10, groundY)
      ..lineTo(x + 10, groundY - 42)
      ..lineTo(x + 74, groundY - 42)
      ..lineTo(x + 74, groundY)
      ..close();

    canvas.drawPath(roof, outlinePaint);
    canvas.drawPath(body, outlinePaint);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 38, groundY - 28, 15, 28),
        const Radius.circular(2),
      ),
      detailPaint,
    );

    canvas.drawRect(Rect.fromLTWH(x + 20, groundY - 30, 12, 12), detailPaint);

    canvas.drawRect(Rect.fromLTWH(x + 58, groundY - 30, 12, 12), detailPaint);
  }

  void _drawCenterHouse(
    Canvas canvas,
    Paint outlinePaint,
    Paint detailPaint,
    double x,
    double groundY,
  ) {
    final roof = Path()
      ..moveTo(x - 8, groundY - 38)
      ..lineTo(x + 36, groundY - 78)
      ..lineTo(x + 80, groundY - 38);

    final body = Path()
      ..moveTo(x + 2, groundY)
      ..lineTo(x + 2, groundY - 38)
      ..lineTo(x + 70, groundY - 38)
      ..lineTo(x + 70, groundY)
      ..close();

    canvas.drawPath(roof, outlinePaint);
    canvas.drawPath(body, outlinePaint);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 30, groundY - 27, 16, 27),
        const Radius.circular(2),
      ),
      detailPaint,
    );

    canvas.drawRect(Rect.fromLTWH(x + 12, groundY - 28, 12, 12), detailPaint);

    canvas.drawRect(Rect.fromLTWH(x + 52, groundY - 28, 12, 12), detailPaint);
  }

  void _drawTallBuilding(
    Canvas canvas,
    Paint outlinePaint,
    Paint detailPaint,
    double x,
    double groundY,
  ) {
    final path = Path()
      ..moveTo(x, groundY)
      ..lineTo(x, groundY - 118)
      ..lineTo(x + 42, groundY - 138)
      ..lineTo(x + 84, groundY - 118)
      ..lineTo(x + 84, groundY)
      ..close();

    canvas.drawPath(path, outlinePaint);

    canvas.drawLine(
      Offset(x + 42, groundY - 138),
      Offset(x + 42, groundY - 8),
      detailPaint,
    );

    for (double row = groundY - 104; row < groundY - 18; row += 17) {
      for (double col = x + 12; col < x + 70; col += 20) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(col, row, 8, 9),
            const Radius.circular(1.5),
          ),
          detailPaint,
        );
      }
    }
  }

  void _drawRightHouse(
    Canvas canvas,
    Paint outlinePaint,
    Paint detailPaint,
    double x,
    double groundY,
  ) {
    final roof = Path()
      ..moveTo(x - 20, groundY - 45)
      ..lineTo(x + 28, groundY - 88)
      ..lineTo(x + 76, groundY - 45);

    final body = Path()
      ..moveTo(x - 8, groundY)
      ..lineTo(x - 8, groundY - 45)
      ..lineTo(x + 64, groundY - 45)
      ..lineTo(x + 64, groundY)
      ..close();

    canvas.drawPath(roof, outlinePaint);
    canvas.drawPath(body, outlinePaint);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 20, groundY - 30, 16, 30),
        const Radius.circular(2),
      ),
      detailPaint,
    );

    canvas.drawRect(Rect.fromLTWH(x + 0, groundY - 32, 12, 12), detailPaint);

    canvas.drawRect(Rect.fromLTWH(x + 45, groundY - 32, 12, 12), detailPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
