// Derived from assets/brand/ld-mark*.svg. Run npm run signature:build.
part of 'leone_signature.dart';

void _paintSignatureMark(Canvas canvas, Size size, bool dark) {
  canvas.save();
  canvas.scale(size.width / 256, size.height / 256);
  canvas.saveLayer(const Rect.fromLTWH(0, 0, 256, 256), Paint());
  final pen =
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
  canvas.drawPath(
    Path()
      ..moveTo(24, 50)
      ..lineTo(24, 196)
      ..quadraticBezierTo(24, 232, 60, 232)
      ..lineTo(180, 232),
    pen..color = dark ? Color(0xFFF3F6F5) : Color(0xFF111318),
  );
  canvas.drawPath(
    Path()
      ..moveTo(50, 24)
      ..lineTo(186, 24)
      ..quadraticBezierTo(232, 24, 232, 70)
      ..lineTo(232, 186)
      ..quadraticBezierTo(232, 232, 186, 232)
      ..lineTo(180, 232),
    pen..color = dark ? Color(0xFFCFC7F4) : Color(0xFF30313A),
  );
  canvas.drawPath(
    Path()
      ..moveTo(176, 240)
      ..lineTo(188, 224),
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..blendMode = BlendMode.clear,
  );
  canvas.restore();
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(155, 155, 48, 48),
      const Radius.circular(17),
    ),
    Paint()..color = const Color(0xFFFF6B55),
  );
  canvas.restore();
}
