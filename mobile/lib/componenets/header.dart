import 'package:flutter/material.dart';

class Header extends CustomPainter {
  final Color color; // Accept color as a parameter

  Header({required this.color});

  double top_height = 64;
  double slope_height = 32;
  double slope_width = 64;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color // Use the passed color
      ..style = PaintingStyle.fill;

    // DRAW THE PATH
    Path path = Path();
    path.moveTo(0, 0); 
    path.lineTo(0, slope_height + top_height); 
    path.lineTo((size.width / 2) - (slope_width / 2), slope_height + top_height);
    path.lineTo((size.width / 2) + (slope_width / 2), top_height);
    path.lineTo(size.width, top_height);
    path.lineTo(size.width, 0);
    path.close();
    
    // DRAWING THE SHAPE
    canvas.drawPath(path, paint);

    // IF YOU WANT TO OVERFLOW IMAGE, YOU CAN ALSO DO THAT HERE
    final imgWidth = size.width;
    final imgHeight = size.height * 0.8; // Adjust the height as needed
    // For now, we aren't adding any image, but you can add an image similarly
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
