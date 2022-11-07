import 'package:flutter/material.dart';
import 'package:puzzle/generated/assets.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          color: const Color(0xffae76ec),
          child: CustomPaint(
            size: size,
            painter: RPSCustomPainter(size),
          ),
        ),
      ],
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  final Size size;

  RPSCustomPainter(this.size);

  @override
  void paint(Canvas canvas, Size size) {
    size = this.size;
    Paint paint0 = Paint()
      ..color = const Color(0xff996ce3)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    Path path0 = Path();
    path0.moveTo(size.width, size.height * 0.1600000);
    path0.quadraticBezierTo(
        size.width * 1.0200000, size.height * 0.2071875, size.width * 0.8350000, size.height * 0.2912500);
    path0.quadraticBezierTo(
        size.width * 0.7281250, size.height * 0.3543750, size.width * 0.7575000, size.height * 0.3950000);
    path0.quadraticBezierTo(
        size.width * 0.7775000, size.height * 0.4828125, size.width * 0.6650000, size.height * 0.5212500);
    path0.quadraticBezierTo(
        size.width * 0.5168750, size.height * 0.5778125, size.width * 0.5525000, size.height * 0.6312500);
    path0.quadraticBezierTo(
        size.width * 0.5718750, size.height * 0.7056250, size.width * 0.5025000, size.height * 0.7675000);
    path0.quadraticBezierTo(
        size.width * 0.3456250, size.height * 0.8109375, size.width * 0.3425000, size.height * 0.8850000);
    path0.quadraticBezierTo(
        size.width * 0.3343750, size.height * 0.9687500, size.width * 0.2625000, size.height);
    path0.lineTo(size.width, size.height * 0.9987500);
    path0.quadraticBezierTo(
        size.width * 1.0118750, size.height * 0.7225000, size.width, size.height * 0.1600000);
    path0.close();

    canvas.drawPath(path0, paint0);

    Paint paint1 = Paint()
      ..color = const Color(0xff996ce3)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path1 = Path();
    path1.moveTo(0, 0);
    path1.quadraticBezierTo(size.width * 0.5668750, size.height * -0.0006250, size.width * 0.7325000, 0);
    path1.quadraticBezierTo(
        size.width * 0.7381250, size.height * 0.0550000, size.width * 0.6275000, size.height * 0.1050000);
    path1.quadraticBezierTo(
        size.width * 0.4975000, size.height * 0.1340625, size.width * 0.4625000, size.height * 0.2037500);
    path1.cubicTo(size.width * 0.4868750, size.height * 0.2696875, size.width * 0.4987500,
        size.height * 0.3078125, size.width * 0.4050000, size.height * 0.3425000);
    path1.cubicTo(size.width * 0.2218750, size.height * 0.3915625, size.width * 0.2606250,
        size.height * 0.4484375, size.width * 0.2225000, size.height * 0.4725000);
    path1.cubicTo(size.width * 0.2600000, size.height * 0.5818750, size.width * 0.2225000,
        size.height * 0.6268750, size.width * 0.1700000, size.height * 0.6550000);
    path1.quadraticBezierTo(
        size.width * 0.0881250, size.height * 0.6962500, size.width * 0.1250000, size.height * 0.7675000);
    path1.quadraticBezierTo(size.width * 0.0750000, size.height * 0.8243750, 0, size.height * 0.8212500);
    path1.quadraticBezierTo(size.width * -0.0012500, size.height * 0.6387500, 0, 0);
    path1.close();

    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
