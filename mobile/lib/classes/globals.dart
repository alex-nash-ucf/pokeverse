import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/pages/editPokemon.dart';
import 'package:mobile/pages/editTeam.dart';
import 'package:mobile/pages/pokemonSearch.dart';
import 'package:mobile/screens/login.dart';

class ScreenManager {
  static final ScreenManager _instance = ScreenManager._internal();
  final StreamController<Widget> _screenStreamController = StreamController<Widget>();

  factory ScreenManager() {
    return _instance;
  }

  ScreenManager._internal() {
    _screenStreamController.add(LoginPage()); 
  }

  // Default screen
  Widget _currentScreen = LoginPage(); //ignore

  // Stream that emits screen changes
  Stream<Widget> get screenStream => _screenStreamController.stream;

  // Method to change the screen
  void setScreen(Widget newScreen) {
    _currentScreen = newScreen;
    _screenStreamController.add(newScreen); // Emit the new screen
  }

  // Get current screen (useful for the initial load)
  Widget get currentScreen => _currentScreen;
}
