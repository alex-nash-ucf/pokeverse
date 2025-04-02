import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/classes/globals.dart';
import 'package:mobile/componenets/screenContainer.dart';
import 'package:mobile/pages/editTeam.dart';
import 'package:mobile/pages/teamSearch.dart';
import 'dart:convert';
import 'package:mobile/screens/login.dart';
import 'package:mobile/screens/hub.dart';
import 'package:mobile/main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool usernameEmpty = false;
  bool emailEmpty = false;
  bool passwordEmpty = false;
  bool signedUp = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      usernameEmpty = false;
      emailEmpty = false;
      passwordEmpty = false;
      signedUp = false;
    });

    final String username = _usernameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // if (username.isEmpty || password.isEmpty || email.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Please fill in all inputs.' , style: TextStyle(color: Colors.black))),
    //   );
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   return;
    // }
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
    if (email.isEmpty) {
      setState(() {
        emailEmpty = true;
      });
    }
    if(emailEmpty || passwordEmpty || usernameEmpty){
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://pokeverse.space:5001/signup'), // UPDATE API CALL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // SignUp successful
        setState(() {
          signedUp = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('SignUp successful', style: TextStyle(color: Colors.black))),
        );
        // Handle the response data (e.g., save user ID, navigate to the next screen)
        print('User ID: ${responseData['id']}');
        print('Username: ${responseData['user']}');
        print('Email: ${responseData['email']}');
        print('Name: ${responseData['firstname']} ${responseData['lastName']}');

        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ScreenContainer(HubScreen())));
      } else {
        // Other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${responseData['error']}', style: TextStyle(color: Colors.black))),
        );
      }
    } catch (e) {
      // Handle network or server errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e', style: TextStyle(color: Colors.black))),
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
                  'Welcome, \nJoin Us Today!',
                  style: TextStyle(
                    fontFamily: 'Pokemon GB',
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  'Already have an account?',
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
                    ScreenManager().setScreen(LoginPage());
                    // Navigator.push(
                    // context,
                    // MaterialPageRoute(builder: (context) => ScreenContainer(LoginPage())),
                    // );
                  },
                  child: Text(
                    'Login here',
                    style: TextStyle(
                      fontFamily: 'Pokemon GB',
                      fontSize: 12,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       width: 120,
                //       child: TextField(
                //         controller: _fnameController,
                //         style: TextStyle(color: Colors.black),
                //         decoration: InputDecoration(
                //           hintText: 'First Name',
                //           hintStyle: TextStyle(color: Colors.black),
                //           filled: true,
                //           fillColor: Colors.grey,
                //           enabledBorder: OutlineInputBorder(
                //             borderSide: BorderSide(color: Colors.grey[600]!),
                //             borderRadius: BorderRadius.circular(20),
                //           ),
                //           focusedBorder: OutlineInputBorder(
                //             borderSide: BorderSide(color: Colors.black), 
                //             borderRadius: BorderRadius.circular(20),
                //           ),
                //           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                //         ),
                //       )
                //     ),
                //     SizedBox(width: 10),
                //     Container(
                //       width: 120,
                //       child: TextField(
                //         controller: _lnameController,
                //         style: TextStyle(color: Colors.black),
                //         decoration: InputDecoration(
                //           hintText: 'Last Name',
                //           hintStyle: TextStyle(color: Colors.black),
                //           filled: true,
                //           fillColor: Colors.grey,
                //           enabledBorder: OutlineInputBorder(
                //             borderSide: BorderSide(color: Colors.grey[600]!),
                //             borderRadius: BorderRadius.circular(20),
                //           ),
                //           focusedBorder: OutlineInputBorder(
                //             borderSide: BorderSide(color: Colors.black), 
                //             borderRadius: BorderRadius.circular(20),
                //           ),
                //           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                //         ),
                //       )
                //     ),
                //   ]
                // ),
                SizedBox(height: 15),
                if(usernameEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                    child: Text(
                      "Please enter a username.",
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
                if(emailEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                    child: Text(
                      "Please enter your email.",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                  ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Email',
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
                      "Please enter a password.",
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontFamily: 'Pokemon GB'),
                  ),
                ),
                if(signedUp)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                    child: Text(
                      "Please verify your email and procceed to login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
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