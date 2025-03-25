import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/screens/SignUp.dart';
import 'package:mobile/screens/hub.dart';
import 'package:mobile/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password', style: TextStyle(color: Colors.black),), ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5001/userlogin'), // Replace with your API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'login': username,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Login successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful', style: TextStyle(color: Colors.black))),
        );
        // Handle the response data (e.g., save user ID, navigate to the next screen)
        print('User ID: ${responseData['id']}');
        print('Username: ${responseData['user']}');
        print('Email: ${responseData['email']}');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ScreenContainer(HubScreen())));
      } else if (response.statusCode == 401) {
        // Invalid credentials
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['error'], style: TextStyle(color: Colors.black))),
        );
      } else {
        // Other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login: ${responseData['error']}', style: TextStyle(color: Colors.black))),
        );
      }
    } catch (e) {
      // Handle network or server errors
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
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 255, 17, 0),
      //   centerTitle: true,
      //   title: Text(
      //     'Pokeverse',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontFamily: 'Pokemon GB'
      //     ), 
      //   ),


      // ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontFamily: 'Pokemon GB',
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    fontFamily: 'Pokemon GB',
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    print('Get Started pressed');
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScreenContainer(SignUpPage())),
                    );
                  },
                  child: Text(
                    'Get Started.',
                    style: TextStyle(
                      fontFamily: 'Pokemon GB',
                      fontSize: 12,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _usernameController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                  
                      hintText: 'Username',
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
                SizedBox(height: 15),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.black),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
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
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontFamily: 'Pokemon GB'),
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