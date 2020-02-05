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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/images/signup.png',height:100.0),
              SignupForm(),
            ],
          ),
        ),
      ),
      drawer:MyDrawer(),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  String usern,pass,confpass,name;
  final _formSkey = GlobalKey<FormState>();
  var Spass=GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formSkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Name:',icon:Icon(Icons.perm_identity),
            ),
            validator: (value) {


              if (value.isEmpty) {
                return 'Enter Your Name!!';
              }
              setState(() {
                name = value;
              });

              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email:',icon:Icon(Icons.email),
            ),
            validator: (value) {
              var pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regex = new RegExp(pattern);

              if (!regex.hasMatch(value)) {
                return 'Please enter a Valid Email!';
              }
              setState(() {
                usern = value;
              });

              return null;
            },
          ),
          TextFormField(
            key: Spass,
            decoration: InputDecoration(labelText: 'Password:',icon:Icon(Icons.lock_outline)),
            obscureText: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Password cannot be empty!';
              }

              setState(() {
                pass = value;
              });

              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Confirm Password:',icon:Icon(Icons.lock_outline)),
            obscureText: true,
            validator: (value) {
              var p=Spass.currentState.value;
              if (value.isEmpty || value!=p) {
                return 'Passwords Dont Match!';
              }



              setState(() {
                confpass = value;
              });

              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0,horizontal:25.0),
            child: ButtonTheme(
              minWidth:MediaQuery.of(context).size.width,
              height: 40.0,

              child: RaisedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formSkey.currentState.validate()) {
                    // If the form is valid, check credentials then redirect
                    print('Username:$usern Password:$pass Name:$name');
                    _formSkey.currentState.reset();
                  }
                },
                child: Text('Submit'),
                textColor: Colors.white,
                color: Colors.blue,




              ),
            ),
          ),
        ],
      ),
    );  }
}
