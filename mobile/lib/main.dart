import 'package:flutter/material.dart';
import 'package:mobile/componenets/carouselItem.dart';
import 'package:mobile/themes/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokeverse',
      // home: LoginPage(),
      home: GettingStartedScreen(),

      theme: lightMode,

      //darkTheme: darkMode,
    );
  }
}

class GettingStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Pokeverse demo",
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontSize: 24,
          ),
        ),
      ),

      body: Column(
        children: [
          // CAROUSEL
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(4, (index) => CarouselItem()),
              ),
            ),
          ),

          //NAVBAR
          Container(
            height: 64,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Equal spacing
                children: [
                  NavBarButton(icon: Icons.home),
                  NavBarButton(icon: Icons.table_rows),
                  NavBarButton(icon: Icons.favorite),
                  NavBarButton(icon: Icons.people_alt),
                  NavBarButton(icon: Icons.exit_to_app),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const NavBarButton({Key? key, required this.icon, this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon, 
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
