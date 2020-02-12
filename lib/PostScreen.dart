import 'package:flutter/material.dart';
import 'package:help4real/main.dart';
import 'package:help4real/LoginScreen.dart';


class MyPostPage extends StatelessWidget {
   String title='Post';



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
      body: Center(child: Text('My Post Page!')),
      drawer:MyDrawer(),
    );
  }
}