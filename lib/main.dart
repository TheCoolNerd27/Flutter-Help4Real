import 'package:flutter/material.dart';
import 'package:help4real/HomeScreen.dart';
import 'package:help4real/LoginScreen.dart';
import 'package:help4real/MyProfileScreen.dart';
import 'package:help4real/PostScreen.dart';
import 'package:help4real/SignupScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:help4real/Login.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'Help 4 Real';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/login': (context) => MyLoginPage(),
        '/Signup':(context) =>MySignupPage(),
        '/MyProfile':(context)=>MyProfilePage(),
        '/Signup2':(context)=>MySignupPage2(),
        '/Post':(context)=>MyPostPage()
      }
    );

  }
}


