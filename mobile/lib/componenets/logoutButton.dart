import 'package:flutter/material.dart';
import 'package:mobile/classes/ApiService.dart';
import 'package:mobile/classes/SecureStorage.dart';
import 'package:mobile/classes/globals.dart';
import 'package:mobile/screens/login.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 32,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      icon: const Icon(Icons.logout),
      tooltip: 'Logout',
      onPressed: () => _logoutPopup(context),
    );
  }

  void _logoutPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await SecureStorage.clearAll();
                  ScreenManager().setScreen(LoginPage());
                  TOKEN = '';
                } catch (e) {
                  print('Logout Error');
                }
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}