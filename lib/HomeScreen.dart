import 'package:flutter/material.dart';
import 'package:help4real/main.dart';
import 'package:help4real/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';


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
      body: Dashboard(),
      drawer:MyDrawer(),
    );
  }
}
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


Widget getData2(){

    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
                case ConnectionState.waiting: return new Text('Loading...');
                default:
                    return new ListView(
                        children: snapshot.data.documents.map((DocumentSnapshot doc) {
                            return new Card(
                                color: Colors.white,
                                child: Column(
                                    children: <Widget>[
                                        ListTile(
                                            leading:CircleAvatar(
                                                // backgroundColor: Colors.orange,


                                                backgroundImage: AssetImage('assets/images/user.png'),
                                            ),
                                            title: Text(doc['uname'], style: Theme.of(context).textTheme.title)
                                        ),


                                            Center(

                                              child: Image.network(
                                                  doc['URL'],height: MediaQuery.of(context).size.height*0.4,
                                              ),
                                            ),
                                        new Container(
                                            padding: const EdgeInsets.all(10.0),
                                            child:
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[

                                                    ListTile(
                                                        leading:Icon(Icons.label),
                                                        title: Text("${doc['tags']}",
                                                            style: TextStyle(color: Colors.black.withOpacity(0.5)))),
                                                    ListTile(
                                                        leading:Icon(Icons.description),
                                                        title: Text("${doc['caption']}")),
                                                ],
                                            ),

                                        )
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                )

                            );
                        }).toList(),
                    );
            }
        },
    );

}

  @override
  Widget build(BuildContext context) {


    return Container(
        child: getData2(),
    );
  }
}
