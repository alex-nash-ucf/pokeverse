import 'package:flutter/material.dart';
import 'package:mobile/componenets/header.dart';
import 'package:mobile/pages/pokemonSearch.dart'; // Ensure this is correctly imported
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
      theme: lightMode, // Add your theme here
      home: ScreenContainer(
        const PokemonSearch(), // Pass PokemonSearch as the screen here
      ),
    );
  }
}

class ScreenContainer extends StatefulWidget {
  final Widget screen;

  const ScreenContainer(this.screen, {super.key});

  @override
  _ScreenContainerState createState() => _ScreenContainerState();
}

class _ScreenContainerState extends State<ScreenContainer> {
  @override
  Widget build(BuildContext context) {
    // Move the screen height retrieval here, inside build()
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // BODY ////////////////////////////////////////////////////////
          Column(
            children: [
              SizedBox(height: 48), // Adjust this padding if necessary
              Expanded(
                child: widget.screen,
              ), // This holds the PokemonSearch widget
            ],
          ),

          // HEADER ////////////////////////////////////////////////////////
          Column(
            children: [
              // RED PADDING for the header area
              Container(
                height: MediaQuery.of(context).padding.top,
                color: Theme.of(context).primaryColor,
              ),

              // Apply the translation (offset the header upwards by screen height)
              Transform.translate(
                offset: Offset(0, 0),
                child: HeaderWithSvg(
                  primaryColor: Theme.of(context).colorScheme.primary,
                  secondaryColor: Theme.of(context).colorScheme.secondary,
                  topHeight: screen_height + 16,
                ),
              ),
            ],
          ),

          Transform.translate(
                offset: Offset(0, 0),
                child: FooterWithSvg(
                  primaryColor: Theme.of(context).colorScheme.primary,
                  secondaryColor: Theme.of(context).colorScheme.secondary,
                  bottomHeight: screen_height + 16,
                ),
            ),
        ],
      ),
    );
  }
}
