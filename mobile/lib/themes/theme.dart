import 'package:flutter/material.dart';

// LIGHT MODE

ThemeData lightMode = ThemeData(
  scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1),
  unselectedWidgetColor: const Color.fromARGB(56, 5, 7, 7),

  colorScheme: ColorScheme(
    brightness: Brightness.light,
    shadow: Color.fromARGB(255, 194, 203, 207),
    
    primary: Color.fromRGBO(255, 0, 0, 1), 
    onPrimary: Color.fromRGBO(255, 125, 125, 1), 
    secondary: Color.fromRGBO(20, 16, 16, 1), 
    onSecondary: Color.fromRGBO(201, 201, 201, 1), 
    
    error: Color.fromRGBO(0, 213, 255, 1), 
    onError: Color.fromRGBO(0, 13, 255, 1), 
    surface: Color.fromRGBO(255, 0, 0, 1), 
    onSurface: Color.fromRGBO(255, 0, 0, 1), 

  )
);



ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
);
