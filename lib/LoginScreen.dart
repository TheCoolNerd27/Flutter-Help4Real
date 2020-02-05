import 'package:flutter/material.dart';
import 'package:help4real/main.dart';

class MyLoginPage extends StatelessWidget {
  var title = 'My Login Page!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
    ),
    ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: <Widget>[
              LoginForm(),
            ],
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formkey = GlobalKey<FormState>();
  String username, password;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Username:'),
            validator: (value) {
              var pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regex = new RegExp(pattern);

              if (!regex.hasMatch(value)) {
                return 'Please enter a Valid Email!';
              }
              setState(() {
                username = value;
              });

              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password:'),
            obscureText: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Password cannot be empty!';
              }

              setState(() {
                password = value;
              });

              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal:16.0),
           child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formkey.currentState.validate()) {
                  // If the form is valid, check credentials then redirect

                }
              },
              child: Text('Submit'),
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
