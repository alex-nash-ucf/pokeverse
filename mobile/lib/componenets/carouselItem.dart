import 'package:flutter/material.dart';

class CarouselItem extends StatelessWidget {

  final Widget child;
  final BoxDecoration decoration;

  const CarouselItem({
    super.key,
    this.child = const Center(
      child: Text(
        'Container',
        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
      ),
    ),

    this.decoration = const BoxDecoration(
      color: Color.fromARGB(255, 255, 255, 255)
    ),

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: child,
    );
  }
}
