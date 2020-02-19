import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help4real/main.dart';
import 'package:help4real/LoginScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
TODO:
1.Add Configuration for iOS for imagePicker
 */
final FirebaseAuth _auth = FirebaseAuth.instance;

class MyPostPage extends StatelessWidget {
  String title = 'Post';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PostForm(),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}

class PostForm extends StatefulWidget {
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _formk = GlobalKey<FormState>();
  File _image;
  String caption, tags;
  FirebaseUser Fuser;
  String name;
  MyDrawer obj = new MyDrawer();
  @override
  void initState() {
    super.initState();

    FirebaseUser udf;
    _auth.onAuthStateChanged.listen((_auth) async {
      udf = await obj.getUSer();
      setState(() {
        Fuser = udf;
        name=udf.displayName;
      });
    });
  }

  void pick() async {
    //pick image   use ImageSource.camera for accessing camera.
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      _image = croppedFile;
    });
  }

  void upload() async {
    //basename() function will give you the filename
    String fileName = path.basename(_image.path);
    var now = new DateTime.now();
    //passing your path with the filename to Firebase Storage Reference
    StorageReference reference =
        FirebaseStorage().ref().child("posts/$now/$fileName");

    //upload the file to Firebase Storage
    StorageUploadTask uploadTask = reference.putFile(_image);

    //TODO: GET PROPER ID AND THEN UPLOAD
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    print('IMAGE:$downloadUrl');
    var ref=Firestore.instance.collection('Posts').document();
    String uid,name;
    var ref2=await Firestore.instance.collection('Organisations')
        .where("email", isEqualTo: Fuser.email).getDocuments()
        .then((data){
        data.documents.forEach((doc)async{
          uid=doc.documentID;
          name=await doc['Name'];
        });
        });






    ref.setData({"URL":downloadUrl,"caption":caption,"uid":Fuser.uid,"uname":'$name',"tags":tags});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formk,
      child: Container(

        child: Column(

          children: <Widget>[
              ListTile(

                leading: CircleAvatar(


                   // backgroundImage: NetworkImage(Fuser.providerId!='firebase'?Fuser.photoUrl:''),
                ),
                  title: Text('$name'),

              ),
            Divider(
              thickness: 0.5,
            ),


            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width:MediaQuery.of(context).size.width*1 ,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        trailing: Icon(Icons.cancel),
                        onTap:(){
                          setState(() {
                            _image=null;
                          });
                        },
                      ),

                      (_image != null
                          ? Image.asset(_image.path,height: MediaQuery.of(context).size.height*0.3)
                          : ButtonTheme(
                        height: MediaQuery.of(context).size.height*0.3,

                            child: FlatButton(onPressed: () {
                        pick();
                      },
                                child: Text('Pick an image')),

                          )

                      ),
                    ],
                  ),



                ),

                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Description:', icon: Icon(Icons.description)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Description is Required!';
                    }

                    setState(() {
                      caption = value;
                    });

                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Tags:', icon: Icon(Icons.label)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Tags are Required!';
                    }

                    setState(() {
                      tags = value;
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
                        if (_formk.currentState.validate()) {
                          // If the form is valid, check credentials then redirect
                         upload();
                          _formk.currentState.reset();
                        }
                      },
                      child: Text('Post'),
                      textColor: Colors.white,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }
}
