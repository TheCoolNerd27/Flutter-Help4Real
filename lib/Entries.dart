import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:help4real/service_locator.dart';
import 'package:help4real/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Entries extends StatefulWidget {
  @override
  _EntriesState createState() => _EntriesState();
}

class _EntriesState extends State<Entries> {
  final _formKey = GlobalKey<FormState>();
  String name, reason, inTime;

  bool isLoaded = false;

  Future<Widget> entryForm(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add New Entry!"),
            content: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Name:'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Name cannot be empty!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Reason of Arrival'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Provide a Reason of Arrival!';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          reason = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(int.parse(
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString()))),
                      ),
                      onSaved: (value) {
                        setState(() {
                          inTime =
                              DateTime.now().millisecondsSinceEpoch.toString();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: RaisedButton(
                        child: Text("Submit"),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            onSubmit();
                          }
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void onSubmit() {
    String outTime = "";
    var ref = Firestore.instance.collection('Entries');
    ref.add({
      "Name": name,
      "Reason of Arrival": reason,
      "In-Time": inTime,
      "Out-Time": outTime,
      "left": false,
    });
  }

  void onExit(String uid) {
    String outTime = DateTime.now().millisecondsSinceEpoch.toString();
    var ref = Firestore.instance.collection("Entries").document(uid);
    ref.updateData({
      "Out-Time": outTime,
      "left": true,
    });
  }

  List<DataRow> _createRows(QuerySnapshot snapshot) {
    List<DataRow> newList = snapshot.documents.map((DocumentSnapshot doc) {
      return new DataRow(
        cells: <DataCell>[
          DataCell(
            Text(doc['Name']),
            showEditIcon: false,
            placeholder: false,
          ),
          DataCell(
            Text(doc['Reason of Arrival']),
            showEditIcon: false,
            placeholder: false,
          ),
          DataCell(
            Text(DateFormat('dd MMM kk:mm').format(
                DateTime.fromMillisecondsSinceEpoch(
                    int.parse(doc['In-Time'])))),
            showEditIcon: false,
            placeholder: false,
          ),
          DataCell(
            doc['left']
                ? Text(DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(doc['Out-Time']))))
                : RaisedButton(
                    onPressed: () => onExit(doc.documentID),
                    child: Text('Mark as Exitted!'),
                  ),
            showEditIcon: false,
            placeholder: false,
          ),
        ],
      );
    }).toList();

    return newList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: Text("Directory"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream: Firestore.instance
                .collection("Entries")
                .orderBy("In-Time", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)));
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                   //header: Text("Entries Log"),
                   columns: <DataColumn>[
                     DataColumn(
                       label: Text("Name"),
                       numeric: false,
                     ),
                     DataColumn(
                       label: Text("Reason of Arrival"),
                       numeric: false,
                     ),
                     DataColumn(
                       label: Text("In-Time"),
                       numeric: false,
                     ),
                     DataColumn(
                       label: Text("Out-Time"),
                       numeric: false,
                     ),
                   ],
                   //rowsPerPage: PaginatedDataTable.defaultRowsPerPage,

                   rows: _createRows(snapshot.data),
                    ),
                );
              }
            },
          ),
          RaisedButton(
              child:Text("Add Entry"),
              onPressed:()=> showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(8.0))),
                  title: Container(

                      color: Colors.blue,
                      padding: EdgeInsets.all(10.0),
                      height: 50.0,
                      child: Center(child: Text("Add New Entry!"))),
                  contentPadding: EdgeInsets.all(0.0),
                  titlePadding:EdgeInsets.all(0.0) ,
                  content: Container(
                    height: 275.0,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(

                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Name:'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Name cannot be empty!';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration:
                                InputDecoration(labelText: 'Reason of Arrival'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Provide a Reason of Arrival!';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  setState(() {
                                    reason = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: DateFormat('dd MMM kk:mm').format(
                                      DateTime.fromMillisecondsSinceEpoch(int.parse(
                                          DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString()))),
                                ),
                                onSaved: (value) {
                                  setState(() {
                                    inTime =
                                        DateTime.now().millisecondsSinceEpoch.toString();
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: RaisedButton(
                                  child: Text("Submit"),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      onSubmit();
                                      _formKey.currentState.reset();
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }))
        ],
      ),
    );

    /*
*/
  }
}
