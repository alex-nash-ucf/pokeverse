import 'package:flutter/material.dart';
import 'package:mobile/themes/theme.dart';

class CarouselItem extends StatelessWidget {

  final Widget child;
  final BoxDecoration decoration;

  const CarouselItem({
    Key? key,
    this.child = const Center(
      child: Text(
        'Container',
        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
      ),
    ),

    this.decoration = const BoxDecoration(
      color: Color.fromARGB(255, 255, 255, 255)
    ),

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: decoration,
      child: child,
    );
  }
}
