import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/lumi_colors.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({super.key, required this.ratio, this.size = 104});

  /// null => hiç görev yok; "—" gösterilir, sahte yüzde gösterilmez.
  final double? ratio;
  final double size;

  @override
  Widget build(BuildContext context) {
    final label = ratio == null ? '—' : '${(ratio! * 100).round()}%';
    return Semantics(
      label: ratio == null ? 'Haftalık ilerleme: görev yok' : 'Haftalık ilerleme yüzde ${(ratio! * 100).round()}',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _RingPainter(ratio ?? 0),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.ratio);
  final double ratio;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 10.0;
    final rect = Rect.fromLTWH(stroke / 2, stroke / 2, size.width - stroke, size.height - stroke);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = LumiColors.mintLight;
    canvas.drawArc(rect, 0, math.pi * 2, false, base);
    if (ratio > 0) {
      final fg = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = LumiColors.mint;
      canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * ratio, false, fg);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.ratio != ratio;
}
