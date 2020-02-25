import 'package:flutter/material.dart';
import 'package:help4real/main.dart';
import 'package:help4real/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class MyProfilePage extends StatefulWidget {
  FirebaseUser Fuser;
  GoogleSignInAccount Guser;
  MyProfilePage();
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  FirebaseUser Fuser;
  MyDrawer obj=new MyDrawer();
  _MyProfilePageState();

   String title='Profile';
    //final FirebaseUser user=;

  @override
  void initState() {
    super.initState();

    FirebaseUser udf;
    _auth.onAuthStateChanged.listen((_auth)async{

      udf=await obj.getUSer();
      setState(() {
        Fuser= udf;
      });
    });
  }


  @override
  Widget build(BuildContext context){


  print('Hello $Fuser');
    return Scaffold(
      appBar:  AppBar(title: Text(title),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Profile(),
      drawer:MyDrawer(),

    );

  }
}
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('My Profile Page!')),
    );
  }
}
