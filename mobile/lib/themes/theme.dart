import 'package:flutter/material.dart';

// LIGHT MODE

ThemeData lightMode = ThemeData(
  scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1),

  colorScheme: ColorScheme(
    brightness: Brightness.light,
    
    primary: Color.fromRGBO(255, 0, 0, 1), 
    onPrimary: Color.fromRGBO(255, 125, 125, 1), 
    secondary: Color.fromRGBO(0, 0, 0, 1), 
    onSecondary: Color.fromRGBO(53, 53, 53, 1), 
    
    error: Color.fromRGBO(0, 213, 255, 1), 
    onError: Color.fromRGBO(0, 13, 255, 1), 
    surface: Color.fromRGBO(255, 0, 0, 1), 
    onSurface: Color.fromRGBO(255, 0, 0, 1), 
  )
);



ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
);
