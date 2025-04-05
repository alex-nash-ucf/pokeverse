import 'package:flutter/material.dart';
import 'package:mobile/componenets/header.dart';
import 'package:mobile/componenets/screenContainer.dart';
import 'package:mobile/pages/editTeam.dart';
import 'package:mobile/pages/pokemonSearch.dart'; // Ensure this is correctly imported
import 'package:mobile/screens/login.dart';
import 'package:mobile/themes/theme.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokeverse',
      theme: lightMode, 
      home: ScreenContainer(),
    );
  }
}

