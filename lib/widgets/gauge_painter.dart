import 'dart:math' as math;
import 'package:flutter/material.dart';

class BmiGauge extends StatefulWidget {
  final double bmi;

  const BmiGauge({super.key, required this.bmi});

  @override
  State<BmiGauge> createState() => _BmiGaugeState();
}

class _BmiGaugeState extends State<BmiGauge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 15.0, end: widget.bmi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant BmiGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bmi != widget.bmi) {
      _animation = Tween<double>(begin: oldWidget.bmi, end: widget.bmi).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
      );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(280, 160),
          painter: BmiGaugePainter(
            bmiValue: _animation.value,
            theme: Theme.of(context),
          ),
        );
      },
    );
  }
}

class BmiGaugePainter extends CustomPainter {
  final double bmiValue;
  final ThemeData theme;

  BmiGaugePainter({required this.bmiValue, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final Offset center = Offset(width / 2, height - 10);
    final double outerRadius = width / 2 - 15;
    final double thickness = 22.0;
    final double innerRadius = outerRadius - thickness;

    // Define sector colors
    const Color colorUnder = Colors.cyan;
    const Color colorNormal = Colors.emerald;
    const Color colorOver = Colors.orange;
    const Color colorObese = Colors.redAccent;

    // Paint options for segments
    final Paint segmentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt; // Clean adjacent segments

    // Draw the 4 segments: each is 45 degrees (pi/4 radians)
    // Angles start from pi (180 degrees - left side) and go to 0 (0 degrees - right side)
    
    // 1. Underweight Segment
    segmentPaint.color = colorUnder.withOpacity(0.85);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius - thickness / 2),
      math.pi,
      0.25 * math.pi,
      false,
      segmentPaint,
    );

    // 2. Normal Segment
    segmentPaint.color = colorNormal.withOpacity(0.85);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius - thickness / 2),
      1.25 * math.pi,
      0.25 * math.pi,
      false,
      segmentPaint,
    );

    // 3. Overweight Segment
    segmentPaint.color = colorOver.withOpacity(0.85);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius - thickness / 2),
      1.5 * math.pi,
      0.25 * math.pi,
      false,
      segmentPaint,
    );

    // 4. Obese Segment
    segmentPaint.color = colorObese.withOpacity(0.85);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius - thickness / 2),
      1.75 * math.pi,
      0.25 * math.pi,
      false,
      segmentPaint,
    );

    // Calculate angle for needle
    final double needleAngle = _getAngleForBmi(bmiValue);

    // Draw the Hub (Center Pin)
    final Paint hubOuterPaint = Paint()
      ..color = theme.colorScheme.onSurface
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 12, hubOuterPaint);

    final Paint hubInnerPaint = Paint()
      ..color = _getColorForBmi(bmiValue)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 6, hubInnerPaint);

    // Draw the Needle
    final double needleLength = outerRadius - thickness - 5;
    final Offset needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    final Paint needlePaint = Paint()
      ..color = theme.colorScheme.onSurface
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(center, needleEnd, needlePaint);

    // Draw a small tip indicator on top of needle
    final Paint needleTipPaint = Paint()
      ..color = _getColorForBmi(bmiValue)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(needleEnd, 3.5, needleTipPaint);

    // Add labels under the sectors
    _drawLabelText(canvas, "18.5", Offset(center.dx - (outerRadius - thickness) * 0.707, center.dy - (outerRadius - thickness) * 0.707 - 5));
    _drawLabelText(canvas, "25.0", Offset(center.dx, center.dy - outerRadius + thickness + 15));
    _drawLabelText(canvas, "30.0", Offset(center.dx + (outerRadius - thickness) * 0.707, center.dy - (outerRadius - thickness) * 0.707 - 5));
  }

  double _getAngleForBmi(double bmi) {
    if (bmi < 15.0) bmi = 15.0;
    if (bmi > 40.0) bmi = 40.0;

    if (bmi < 18.5) {
      double pct = (bmi - 15.0) / (18.5 - 15.0);
      return math.pi + (pct * 0.25 * math.pi);
    } else if (bmi < 25.0) {
      double pct = (bmi - 18.5) / (25.0 - 18.5);
      return 1.25 * math.pi + (pct * 0.25 * math.pi);
    } else if (bmi < 30.0) {
      double pct = (bmi - 25.0) / (30.0 - 25.0);
      return 1.5 * math.pi + (pct * 0.25 * math.pi);
    } else {
      double pct = (bmi - 30.0) / (40.0 - 30.0);
      return 1.75 * math.pi + (pct * 0.25 * math.pi);
    }
  }

  Color _getColorForBmi(double bmi) {
    if (bmi < 18.5) return Colors.cyan;
    if (bmi < 25.0) return Colors.emerald;
    if (bmi < 30.0) return Colors.orange;
    return Colors.redAccent;
  }

  void _drawLabelText(Canvas canvas, String text, Offset position) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: theme.textTheme.bodySmall?.color?.withOpacity(0.6) ?? Colors.grey,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(position.dx - textPainter.width / 2, position.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant BmiGaugePainter oldDelegate) {
    return oldDelegate.bmiValue != bmiValue || oldDelegate.theme != theme;
  }
}
