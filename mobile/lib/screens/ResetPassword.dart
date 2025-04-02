import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/classes/ApiService.dart';
import 'package:mobile/classes/globals.dart';
import 'package:mobile/componenets/screenContainer.dart';
import 'package:mobile/pages/editTeam.dart';
import 'package:mobile/pages/teamSearch.dart';
import 'dart:convert';
import 'package:mobile/screens/SignUp.dart';
import 'package:mobile/screens/hub.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/login.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email.', style: TextStyle(color: Colors.black),), ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://pokeverse.space:5001/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Login successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Link sent', style: TextStyle(color: Colors.black))),
        );

        
        // Handle the response data (e.g., save user ID, navigate to the next screen)
        print('token: ${responseData['token']}');
        TOKEN = responseData['token'];

      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['error'], style: TextStyle(color: Colors.black))),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send link: ${responseData['error']}', style: TextStyle(color: Colors.black))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e', style: TextStyle(color: Colors.black)),),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Reset Password',
                  style: TextStyle(
                    fontFamily: 'Pokemon GB',
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Enter your email below, and we\'ll send you a link to \nreset your password.',
                  style: TextStyle(
                    fontFamily: 'Pokemon GB',
                    fontSize: 12,
                    color: Colors.black,
                    
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                  
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.grey,
                  
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black), 
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                    padding: EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Send Reset Link',
                    style: TextStyle(color: Colors.white, fontFamily: 'Pokemon GB'),
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    ScreenManager().setScreen(LoginPage());
                  },
                  child: Text(
                    'Back to Login',
                    style: TextStyle(
                      fontFamily: 'Pokemon GB',
                      fontSize: 12,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}