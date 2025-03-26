import 'package:flutter/material.dart';

class PokeballLoader extends StatefulWidget {
  @override
  _PokeballLoaderState createState() => _PokeballLoaderState();
}

class _PokeballLoaderState extends State<PokeballLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450 ), 
      vsync: this,
    )..repeat(); 


    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, 
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curvedAnimation, 
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Theme.of(context).unselectedWidgetColor, 
          BlendMode.srcIn, 
        ),
        child: Image.asset(
          'assets/images/pokeball.png', 
          height: 50, 
          width: 50,
        ),
      ),
      builder: (context, child) {
        return Transform.rotate(
          angle: _curvedAnimation.value * 2.0 * 3.14159 /2, 
          child: child,
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Spinning Pokeball')),
      body: Center(
        child: PokeballLoader(),
      ),
    ),
  ));
}
