import 'package:flutter/material.dart';

/// Referanstaki gün batımı manzarasının hafif, vektörel yaklaşımı.
/// Gerçek illüstrasyon (PNG/SVG) eklendiğinde bu bileşen onunla değiştirilebilir.
class SkyHeader extends StatelessWidget {
  const SkyHeader({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _SkyPainter()),
    );
  }
}

class _SkyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Gökyüzü: lavanta -> pembe -> şeftali -> krem
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFC9B8F5), Color(0xFFF3C4D8), Color(0xFFFFD9B8), Color(0xFFF8F4EE)],
        stops: [0.0, 0.45, 0.8, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    // Güneş
    final sunC = Offset(w * 0.55, h * 0.62);
    canvas.drawCircle(
      sunC,
      46,
      Paint()
        ..color = const Color(0xFFFFF1D0).withOpacity(0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22),
    );
    canvas.drawCircle(sunC, 15, Paint()..color = const Color(0xFFFFF4D6));

    // Uzak dağlar
    final far = Path()
      ..moveTo(0, h * 0.78)
      ..lineTo(w * 0.22, h * 0.66)
      ..lineTo(w * 0.40, h * 0.74)
      ..lineTo(w * 0.68, h * 0.52)
      ..lineTo(w * 0.86, h * 0.68)
      ..lineTo(w, h * 0.6)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(far, Paint()..color = const Color(0xFFB9A4E3).withOpacity(0.75));

    // Yakın tepeler
    final near = Path()
      ..moveTo(0, h * 0.86)
      ..quadraticBezierTo(w * 0.25, h * 0.74, w * 0.5, h * 0.84)
      ..quadraticBezierTo(w * 0.78, h * 0.94, w, h * 0.8)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(near, Paint()..color = const Color(0xFF8E7BC4).withOpacity(0.55));

    // Alt kısımda kremle yumuşak geçiş
    final fade = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x00F8F4EE), Color(0xFFF8F4EE)],
      ).createShader(Rect.fromLTWH(0, h * 0.8, w, h * 0.2));
    canvas.drawRect(Rect.fromLTWH(0, h * 0.8, w, h * 0.2), fade);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
