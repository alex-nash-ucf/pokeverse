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
import 'package:email_validator/email_validator.dart';


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
  bool validEmail = true;
  bool _isLoading = false;
  // Password requirements
  bool passwordChanged = false;
  bool isMinLength = false;
  bool hasOneUppercase = false;
  bool hasOneLowercase = false;
  bool hasOneNumber = false;
  bool hasSpecialChar = false;

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
      validEmail = true;
      passwordChanged = false;
      isMinLength = false;
      hasOneUppercase = false;
      hasOneLowercase = false;
      hasOneNumber = false;
      hasSpecialChar = false;
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

    if(emailEmpty || passwordEmpty || usernameEmpty || !_isValidPassword()){
      setState(() {
        _isLoading = false;
        passwordChanged = true;
      });
      _checkPasswordRequirements(password);
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
        setState(() {
          validEmail = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('${responseData['error']}', style: TextStyle(color: Colors.black))),
        // );
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

  void _checkPasswordRequirements(String password){
    setState(() {
      isMinLength = password.length >= 8;
      hasOneUppercase = password.contains(RegExp(r'[A-Z]'));
      hasOneLowercase = password.contains(RegExp(r'[a-z]'));
      hasOneNumber = password.contains(RegExp(r'[0-9]'));
      hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  bool _isValidPassword(){
    return isMinLength && hasOneLowercase && hasOneUppercase && hasOneNumber && hasSpecialChar;
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
                Image(image: AssetImage('assets/images/Pokeverse_Logo.png'),),
                SizedBox(height: 15,),
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
                if(!validEmail)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                    child: Text(
                      "Please enter a valid email.",
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
                    onChanged: (value) {
                      setState(() {
                        passwordChanged = true;
                        _checkPasswordRequirements(value);
                      });
                    },
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
                if(passwordChanged)
                  _buildPasswordRequirements(),
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
                        fontFamily: 'Pokemon GB'
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRequirements(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Password must contain:',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        // Insert requirement text
        _buildRequirementText('At least 8 characters', isMinLength),
        _buildRequirementText('At least one uppercase letter', hasOneUppercase),
        _buildRequirementText('At least one lowercase letter', hasOneLowercase),
        _buildRequirementText('At least one number', hasOneNumber),
        _buildRequirementText('At least one special character', hasSpecialChar),
      ],
    );
  }

  Widget _buildRequirementText(String requirement, bool isMet){
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          isMet ? Icons.check : Icons.close,
          color: isMet ? Colors.green : Colors.red,
          size: 15,
        ),
        SizedBox(width: 2),
        Text(
          requirement,
          style: TextStyle(
            color: isMet ? Colors.green : Colors.red,
            fontSize: 15,
          ),
        )
      ],
    );
  }
}