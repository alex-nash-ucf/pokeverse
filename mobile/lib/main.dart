import 'package:flutter/material.dart';
import 'package:mobile/componenets/carouselItem.dart';
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
                children: List.generate(
                  4,
                  (index) => CarouselItem(), 
                ),
              ),
            ),
          ),

          //NAVBAR
          Container(
            height: 64,
            color: const Color.fromARGB(255, 114, 114, 255),
          ),
        ],
      ),
    );
  }
}
