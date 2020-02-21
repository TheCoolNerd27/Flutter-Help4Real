import 'package:flutter/material.dart';
import 'package:help4real/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:help4real/LoginScreen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class MySignupPage extends StatelessWidget {
  String title = "Register";


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/signup.png'),
                maxRadius: 60.0,
              ),

                SignupForm(),


            ],
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
class MySignupPage2 extends StatelessWidget {
  String title = "Register";


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/signup.png'),
                maxRadius: 60.0,
              ),
              SignupForm2(),



            ],
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  String usern, pass, confpass, name, desc, address, city, contact,_userEmail;
  final _formSkey = GlobalKey<FormState>();
  var Spass = GlobalKey<FormFieldState>();
  bool _success;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formSkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Name:',
              icon: Icon(Icons.perm_identity),
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
          SizedBox(height: 10.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email:',
              icon: Icon(Icons.email),
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

          SizedBox(height: 10.0),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Address:', icon: Icon(Icons.location_on)),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please Enter the address!';
              }

              setState(() {
                address = value;
              });

              return null;
            },
          ),
          SizedBox(height: 10.0),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'City:', icon: Icon(Icons.location_city)),
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter your City!';
              }

              setState(() {
                city = value;
              });

              return null;
            },
          ),
          SizedBox(height: 10.0),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Description:', icon: Icon(Icons.description)),
            validator: (value) {
              if (value.isEmpty) {
                return 'Description is Required!';
              }

              setState(() {
                desc = value;
              });

              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Mobile No:', icon: Icon(Icons.phone)),
            validator: (value) {
              if (value.isEmpty) {
                return 'Contact Details Required!';
              } else if (value.length < 10) {
                return 'Invalid Contact Number!';
              }

              setState(() {
                contact = value;
              });

              return null;
            },
          ),
          SizedBox(height: 10.0),
          TextFormField(
            key: Spass,
            decoration: InputDecoration(
                labelText: 'Password:', icon: Icon(Icons.lock_outline)),
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
          SizedBox(height: 10.0),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Confirm Password:', icon: Icon(Icons.lock_outline)),
            obscureText: true,
            validator: (value) {
              var p = Spass.currentState.value;
              if (value.isEmpty || value != p) {
                return 'Passwords Dont Match!';
              }

              setState(() {
                confpass = value;
              });

              return null;
            },
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              height: 40.0,
              child: RaisedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formSkey.currentState.validate()) {
                    // If the form is valid, check credentials then redirect
                    print('Username:$usern Password:$pass Name:$name');
                    _registerO();
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
    );
  }
  void _registerO() async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: usern,
      password: pass,
    ))
        .user;
    var ref=Firestore.instance.collection('Organisations').document(user.uid);
    ref.setData({"email":user.email,"Name":name,"Desc":desc,"Address":address,"City":city,"Contact":contact});
    print('$user');
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      _success = false;
    }
  }
}

class SignupForm2 extends StatefulWidget {
  @override
  _SignupForm2State createState() => _SignupForm2State();
}

class _SignupForm2State extends State<SignupForm2> {
  String name, email, password, confirm,_userEmail;
  bool _success;
  final _fkey = GlobalKey<FormState>();
  var _pkey = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _fkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Name:',
              icon: Icon(Icons.perm_identity),
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
          SizedBox(height: 10.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email:',
              icon: Icon(Icons.email),
            ),
            validator: (value) {
              var pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regex = new RegExp(pattern);

              if (!regex.hasMatch(value)) {
                return 'Please enter a Valid Email!';
              }
              setState(() {
                email = value;
              });

              return null;
            },
          ),
          SizedBox(height: 10.0),
          TextFormField(
            key: _pkey,
            decoration: InputDecoration(
                labelText: 'Password:', icon: Icon(Icons.lock_outline)),
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
          SizedBox(height: 10.0),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Confirm Password:', icon: Icon(Icons.lock_outline)),
            obscureText: true,
            validator: (value) {
              var p = _pkey.currentState.value;
              if (value.isEmpty || value != p) {
                return 'Passwords Dont Match!';
              }

              setState(() {
                confirm = value;
              });

              return null;
            },
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              height: 40.0,
              child: RaisedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_fkey.currentState.validate()) {
                    // If the form is valid, check credentials then redirect
                    print('Username:$email Password:$password Name:$name');
                    _registerH();

                    _fkey.currentState.reset();
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
    );
  }
  void _registerH() async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    var ref=Firestore.instance.collection('Helpers').document(user.uid);
    ref.setData({"email":user.email,"Name":user.displayName});
    print('$user');
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      _success = false;
    }
  }
}

