import 'package:flutter/material.dart';
//import 'package:help4real/main.dart';
import 'package:help4real/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:help4real/PostScreen.dart';
import 'package:help4real/MyProfileScreen.dart';
import 'package:help4real/service_locator.dart';
import 'package:help4real/auth_service.dart';
//final FirebaseAuth _auth = FirebaseAuth.instance;
final AuthenticationService _authenticationService =
locator<AuthenticationService>();
//TODO:Create Abstract class of Auth service to access everywhere
class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MyDrawer obj=MyDrawer();

  int _selectedIndex = 0;
  FirebaseUser user;
 static bool isHelp=true;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    Container(
      child: Dashboard(),
    ),
    Search(),
    (isHelp?Profile():PostForm())
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.onAuthStateChanged.listen((user) async{

        FirebaseUser udf;
        udf=await _authenticationService.getUSer();
        setState(() {
            user= udf;
        });
        if(user==null)
            {
                setState(() {
                  isHelp=true;
                });
            }
        var ref2=await Firestore.instance.collection('Organisations')
            .document(user.uid).get()
            .then((data){
            if(data==null)
                setState(() {
                    isHelp=true;
                });
            else
                setState(() {
                    isHelp=false;
                });


        });

    });

  }


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
            bottom:Radius.circular(30),
                ),
            ),
        ),
            body:  Container(child: _widgetOptions.elementAt(_selectedIndex)),
              bottomNavigationBar: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        title: Text('Home'),
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        title: Text('Search'),
                    ),
                  (isHelp?BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    title: Text('My Profile'),
                  ):
                  BottomNavigationBarItem(
                        icon: Icon(Icons.fiber_new),
                        title: Text('New Post'),
                    )),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.amber[800],
                onTap: _onItemTapped,
              ),
          drawer: MyDrawer(),
              ),





    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Widget getData2() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Posts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot doc) {
                return new Card(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30.0,
                          child: ListTile(
                              leading: SizedBox(
                                width: 30.0,
                                child: CircleAvatar(
                                  // backgroundColor: Colors.orange,

                                  backgroundImage:
                                      AssetImage('assets/images/user.png'),
                                ),
                              ),
                              title: Text(doc['uname'],
                                  style: Theme.of(context).textTheme.title)),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          child: Image.network(
                            doc['URL'],
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                        ),
                        new Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                  leading: Icon(Icons.description),
                                  title: Text("${doc['caption']}"),
                                  subtitle: Text("${doc['tags'].toString()}",
                                      style: TextStyle(
                                          color:
                                              Colors.black.withOpacity(0.5)))),
                            ],
                          ),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ));
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

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String tagF = '';

  Widget getResult(String tag) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Posts')
          .where('tags', arrayContains: tag)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return Expanded(
              child: SizedBox(

                child: new ListView(
                  children: snapshot.data.documents.map((DocumentSnapshot doc) {
                    return new Card(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                                leading: CircleAvatar(
                                  // backgroundColor: Colors.orange,

                                  backgroundImage:
                                      AssetImage('assets/images/user.png'),
                                ),
                                title: Text(doc['uname'],
                                    style: Theme.of(context).textTheme.title)),
                            Center(
                              child: Image.network(
                                doc['URL'],
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                              ),
                            ),
                            new Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                      leading: Icon(Icons.description),
                                      title: Text("${doc['caption']}"),
                                      subtitle: Text("${doc['tags']}",
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.5)))),
                                ],
                              ),
                            )
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ));
                  }).toList(),
                ),
              ),
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width*0.8,
          child: TextField(
            decoration: InputDecoration(
                labelText: 'Search Tags:', icon: Icon(Icons.label)),
            onSubmitted: (value) {
              setState(() {
                tagF = value;
              });
            },
          ),
        ),
        Container(child: getResult(tagF)),
      ],
    );
  }
}
