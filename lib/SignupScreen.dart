import 'package:flutter/material.dart';
import 'package:help4real/main.dart';



class MySignupPage extends StatelessWidget {
   String title="SignUp";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: Text(title),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Center(child: Text('My SignUp Page!')),
      drawer:MyDrawer(),
    );
  }
}