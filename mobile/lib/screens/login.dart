import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/classes/ApiService.dart';
import 'package:mobile/classes/SecureStorage.dart';
import 'package:mobile/classes/globals.dart';
import 'package:mobile/componenets/screenContainer.dart';
import 'package:mobile/pages/editTeam.dart';
import 'package:mobile/pages/teamSearch.dart';
import 'package:mobile/screens/ResetPassword.dart';
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
  bool usernameEmpty = false;
  bool passwordEmpty = false;
  bool isUser = true;
  bool _isLoading = false;
  bool rememberMe = false;

  @override
  void initState(){
    super.initState();
    _loadSavedLogin();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedLogin() async {
    try {
      final savedUsername = await SecureStorage.getUsername();
      final savedPassword = await SecureStorage.getPassword();
      
      if (savedUsername != null && savedPassword != null) {
        setState(() {
          _usernameController.text = savedUsername;
          _passwordController.text = savedPassword;
          rememberMe = true;
        });
      }
    } catch (e){
      print("Error loading saved credenial: $e");
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      usernameEmpty = false;
      passwordEmpty = false;
      isUser = true;
    });

    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty) {
      setState(() {
        usernameEmpty = true;
      });
    }
    if (password.isEmpty) {
      setState(() {
        passwordEmpty = true;
      });
    }
    if(passwordEmpty || usernameEmpty){
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://pokeverse.space:5001/userlogin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'login': username,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Login successful
        print('token: ${responseData['token']}');
        TOKEN = responseData['token'];
        await SecureStorage.saveToken(TOKEN);

      if (rememberMe) {
        await SecureStorage.saveCredentials(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        await SecureStorage.clearCredentials();
      }

        // GO TO SCREEN
        ScreenManager().setScreen(TeamSearch());

      } else if (response.statusCode == 401) {
        // Invalid credentials
        setState(() {
          isUser = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(responseData['error'], style: TextStyle(color: Colors.black))),
        // );
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
                    ScreenManager().setScreen(SignUpPage());
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
                if(usernameEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                    child: Text(
                      "Please enter your username.",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                  ),

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
                if(passwordEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                    child: Text(
                      "Please enter your password.",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                  ),

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
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: rememberMe, 
                      onChanged: (value){
                        setState(() {
                          rememberMe = value ?? false;
                        });
                        // print(rememberMe);
                      },
                      activeColor: Colors.blue,
                      checkColor: Colors.black,
                    ),
                    Text(
                      'Remember me.',
                      style: TextStyle(
                        fontFamily: 'Pokemon GB',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                if(!isUser)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                    child: Text(
                      "Either username or password is incorrect.",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                  ),
                SizedBox(height: 15),
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
                SizedBox(height: 15,),
                GestureDetector(
                  onTap: () {
                    ScreenManager().setScreen(ResetPasswordPage()); // Add new page
                  },
                  child: Text(
                    'Forgot Password?',
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