import 'package:flutter/material.dart';
import 'package:mobile/componenets/header.dart';
import 'package:mobile/screens/hub.dart';
import 'package:mobile/screens/login.dart';
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
        home: ScreenContainer(LoginPage()), // INSERT SCREEN HERE FOR UNIVERSAL HEADER
        theme: lightMode
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
    return Stack(
      children: [

        // BODY ////////////////////////////////////////////////////////
        Positioned.fill(
          top: 64.0, 
          child: widget.screen,
        ),


        // HEADER ////////////////////////////////////////////////////////
        Column(
          children: [
            // RED PADDING
            Container(
              height: MediaQuery.of(context).padding.top,
              color: Theme.of(context).primaryColor,
            ),

            CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 128),
                painter: Header(Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary),
                
            ),
          ],
        ),
      ],
    );
  }
}
