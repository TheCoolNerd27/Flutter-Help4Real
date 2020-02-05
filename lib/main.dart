import 'package:flutter/material.dart';
import 'package:help4real/HomeScreen.dart';
import 'package:help4real/LoginScreen.dart';
import 'package:help4real/MyProfileScreen.dart';
import 'package:help4real/PostScreen.dart';
import 'package:help4real/SignupScreen.dart';

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
        '/Post':(context)=>MyPostPage()
      }
    );

  }
}


class MyDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
            ListTile(
                title: Text('Dashboard'),
                onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pushNamed(context,'/');
                },
            ),
          ListTile(
            title: Text('Login'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushNamed(context,'/login');
            },
          ),
          ListTile(
            title: Text('Signup'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushNamed(context,'/Signup');
            },
          ),
            ListTile(
                title: Text('My Profile'),
                onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pushNamed(context,'/MyProfile');
                },
            ),
            ListTile(
                title: Text('New Post'),
                onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pushNamed(context,'/Post');
                },
            ),
        ],
      ),
    );
  }
}