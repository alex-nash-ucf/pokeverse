import 'package:flutter/material.dart';

class Header extends CustomPainter {
  final Color primary_color;
  final Color secondary_color;

  Header(this.primary_color, this.secondary_color);

  double top_height = 64;
  double slope_height = 32;
  double slope_width = 64;
  double line_width = 8;

  @override
  void paint(Canvas canvas, Size size) {
    
    //SHAPE
    Paint paint = Paint()
      ..color = primary_color 
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

    
    // LINE
    Paint paint2 = Paint()
      ..color = secondary_color
      ..style = PaintingStyle.fill;

    // DRAW THE PATH
    Path path2 = Path();
    path2.moveTo(0, 0); 
    path2.lineTo(0, slope_height + top_height + line_width); 
    path2.lineTo((size.width / 2) - (slope_width / 2), slope_height + top_height + line_width);
    path2.lineTo((size.width / 2) + (slope_width / 2), top_height + line_width);
    path2.lineTo(size.width, top_height + line_width);
    path2.lineTo(size.width, 0);
    path2.close();
    
    // DRAWING THE LINE
    //canvas.drawPath(path2, paint2,);

    // DRAWING THE SHAPE
    canvas.drawPath(path, paint);
    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
