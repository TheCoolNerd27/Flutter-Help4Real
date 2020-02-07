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
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              Image.asset('assets/images/welcome.jpg',height: MediaQuery.of(context).size.height*0.15),
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
 String username,password;
  var pass=GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Email',icon:Icon(Icons.email),
            ),
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
            key: pass,
            decoration: InputDecoration(labelText: 'Password:',icon:Icon(Icons.vpn_key)),
            obscureText: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Password cannot be empty!';
              }
              else if(value.length<8)
                return 'Password should be atleast 8 characters long!';

              setState(() {
                password = value;
              });

              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0,horizontal:25.0),
           child: ButtonTheme(
             minWidth:MediaQuery.of(context).size.width,
             height: 40.0,

             child: Column(
               children: <Widget>[
                 RaisedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formkey.currentState.validate()) {
                        // If the form is valid, check credentials then redirect
                        print('Username:$username Password:$password');
                        _formkey.currentState.reset();
                      }
                    },
                    child: Text('Login'),
                   textColor: Colors.white,
                    color: Colors.blue,




                  ),
                 SizedBox( height:15.0),
                 RaisedButton(
                   
                   onPressed: () {
                     // Validate returns true if the form is valid, or false
                     // otherwise.
                     if (_formkey.currentState.validate()) {
                       // OAuth Here Remove If too.

                       _formkey.currentState.reset();
                     }
                   },

                   child: Row(
                     children: <Widget>[
                       Image.asset('assets/images/google.png',
                       height:30.0,width:30.0),
                       SizedBox( width:30.0),
                       Text('Sign in with Google'),
                     ],
                   ),
                   textColor: Colors.black,
                   color: Colors.white,




                 ),
               ],
             ),
           ),
          ),
        ],
      ),
    );
  }
}