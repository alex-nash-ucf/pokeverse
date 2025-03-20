import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:mobile/componenets/carouselItem.dart';
import 'package:mobile/screens/main.dart';
import 'package:mobile/themes/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokeverse',
      home: MainScreen(),
      theme: lightMode,
    );
  }
}

