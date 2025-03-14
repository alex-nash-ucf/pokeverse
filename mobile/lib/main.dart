import 'package:flutter/material.dart';
import 'package:mobile/themes/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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


class GettingStartedScreen extends StatelessWidget{

  @override Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("WHY DOSNT THE TEXT SHOW UP"),
        ),

        body: Column(
            children: [
                Container(color: Colors.green, height: 55,),
                Container(color: const Color.fromARGB(255, 109, 76, 175), height: 100,)
            ],
        ),
    );
  }
}


