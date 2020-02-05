import 'package:flutter/material.dart';
import 'package:help4real/main.dart';



class MyProfilePage extends StatelessWidget {
   String title='Profile';



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
      body: Center(child: Text('My Profile Page!')),
      drawer:MyDrawer(),
    );
  }
}