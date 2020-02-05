import 'package:flutter/material.dart';
import 'package:help4real/main.dart';



class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

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
      body: Center(child: Text('My Home Page!')),
      drawer:MyDrawer(),
    );
  }
}