import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends CustomPainter {
  final Color primary_color;
  final Color secondary_color;
  final double top_height; // screenHeight is passed as top_height.

  Header(this.primary_color, this.secondary_color, this.top_height);

  double slope_height = 64;
  double slope_width = 128;
  double line_width = 6;

@override
void paint(Canvas canvas, Size size) {
  // Calculate the offset based on the screen width
  double offset = top_height - 16;

  // SHADOW
  Paint shadowPaint = Paint()
    ..color = Colors.black.withOpacity(0.3)  // Shadow color (e.g., black with some transparency)
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, 32);  // Blur effect for the shadow
  
  // SHAPE FILL
  Paint fillPaint = Paint()
    ..color = primary_color
    ..style = PaintingStyle.fill;

  // SHAPE OUTLINE
  Paint outlinePaint = Paint()
    ..color = secondary_color
    ..style = PaintingStyle.stroke
    ..strokeWidth = line_width
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true;

  // DRAW THE PATH WITH OFFSET
  Path path = Path();
  path.moveTo(-16, 0 - offset);
  path.lineTo(-16, slope_height + top_height - offset);
  path.lineTo((size.width / 2) - (slope_width / 2), slope_height + top_height - offset);
  path.lineTo((size.width / 2) + (slope_width / 2), top_height - offset);
  path.lineTo(size.width + 16, top_height - offset);
  path.lineTo(size.width + 16, 0 - offset);
  path.close();

  // DRAW THE SHADOW (apply before fill and outline)
  canvas.drawPath(path, shadowPaint);

  // DRAW THE FILL
  canvas.drawPath(path, fillPaint);

  // DRAW THE OUTLINE
  canvas.drawPath(path, outlinePaint);
}


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HeaderWithSvg extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final double topHeight;

  HeaderWithSvg({
    required this.primaryColor,
    required this.secondaryColor,
    required this.topHeight,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Header(primaryColor, secondaryColor, topHeight),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Access the screen size via the constraints
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          return Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Transform.translate(
                  offset: Offset(0, 16),
                  child: Container(
                    width: (width / 2) - (128 / 2), // slope_width is 128
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(4, 0,0,0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/Blue.svg', // Replace with your actual SVG path
                          ),
                          SvgPicture.asset(
                            'assets/svg/Yellow.svg', // Replace with your actual SVG path
                          ),
                          SvgPicture.asset(
                            'assets/svg/Green.svg', // Replace with your actual SVG path
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////

class Footer extends CustomPainter {
  final Color primary_color;
  final Color secondary_color;
  final double bottom_height; // screenHeight is passed as bottom_height.

  Footer(this.primary_color, this.secondary_color, this.bottom_height);

  double slope_height = 64;
  double slope_width = 128;
  double line_width = 6;
  double extra_height = 48;

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the offset based on the screen height
    double offset = bottom_height;

    // SHAPE FILL
    Paint fillPaint =
        Paint()
          ..color = primary_color
          ..style = PaintingStyle.fill;

    // SHAPE OUTLINE
    Paint outlinePaint =
        Paint()
          ..color = secondary_color
          ..style = PaintingStyle.stroke
          ..strokeWidth = line_width
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true;

    Path path = Path();
    path.moveTo(-16, offset * 2); 
    path.lineTo(-16, offset - extra_height); 

    path.lineTo((size.width / 2) - (slope_width / 2), offset - extra_height); 
    path.lineTo((size.width / 2) + (slope_width / 2), offset - extra_height - slope_height); 

    path.lineTo(16 + size.width,  offset  - extra_height - slope_height); 
    path.lineTo(16 + size.width,  offset * 2 ); 
    path.close();

    // DRAW THE FILL
    canvas.drawPath(path, fillPaint);

    // DRAW THE OUTLINE
    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class FooterWithSvg extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final double bottomHeight;

  FooterWithSvg({
    required this.primaryColor,
    required this.secondaryColor,
    required this.bottomHeight,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Footer(primaryColor, secondaryColor, bottomHeight),
      
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Access the screen size via the constraints
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          return Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight, // Align the SVG elements to the top
                child: Transform.translate(
                  offset: Offset(0, -4), // Adjust to align better in footer
                  child: Container( 
                    width: (width / 2) - (128 / 2), 
                    height: 64 + 14,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/White.svg', 
                        ),
                        SvgPicture.asset(
                          'assets/svg/Red.svg', 
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}