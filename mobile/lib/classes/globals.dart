import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/classes/ApiService.dart';
import 'package:mobile/classes/SecureStorage.dart';
import 'package:mobile/pages/editPokemon.dart';
import 'package:mobile/pages/editTeam.dart';
import 'package:mobile/pages/pokemonSearch.dart';
import 'package:mobile/pages/teamSearch.dart';
import 'package:mobile/screens/login.dart';

class ScreenManager {
  static final ScreenManager _instance = ScreenManager._internal();
  final StreamController<Widget> _screenStreamController = StreamController<Widget>.broadcast();
  Widget _currentScreen = const Scaffold(body: Center(child: CircularProgressIndicator()));

  factory ScreenManager() {
    return _instance;
  }

  ScreenManager._internal() {
    _initialize();
  }

  Future<void> _initialize() async {
    _currentScreen = await _checkLoginStatus();
    _screenStreamController.add(_currentScreen);
  }

  Future<bool> _validateToken(String token) async {
  try {
    final response = await http.post(
      Uri.parse('http://pokeverse.space:5001/userlogin'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'login': await SecureStorage.getUsername(),
        'password': await SecureStorage.getPassword(),
        'token': token,
      }),
    );
    return response.statusCode == 200;
  } catch (e) {
    print('Validation error: $e');
    return false;
  }
}

  Future<Widget> _checkLoginStatus() async {
    final token = await SecureStorage.getToken();
    final username = await SecureStorage.getUsername();
    
    if (token != null && username != null) {
      try {
        final isValid = await _validateToken(token);
        if(isValid){
          TOKEN = token;
          return TeamSearch();
        }
        return LoginPage();
      } catch (e) {
        await SecureStorage.clearAll();
        return LoginPage();
      }
    }
    return LoginPage();
  }

  Stream<Widget> get screenStream => _screenStreamController.stream;

  void setScreen(Widget newScreen) {
    _currentScreen = newScreen;
    _screenStreamController.add(newScreen);
  }

  Future<void> handleSuccessfulLogin(String token, String username, bool rememberMe) async {
    if (rememberMe) {
      await SecureStorage.saveCredentials(username, '');
      await SecureStorage.saveToken(token);
    }
    setScreen(TeamSearch());
  }

  Future<void> logout() async {
    await SecureStorage.clearAll();
    setScreen(LoginPage());
  }

  Widget get currentScreen => _currentScreen;

  void dispose() {
    _screenStreamController.close();
  }
}