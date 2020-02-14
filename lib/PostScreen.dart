import 'package:flutter/material.dart';
import 'package:help4real/main.dart';
import 'package:help4real/LoginScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path/path.dart' as path;



class MyPostPage extends StatelessWidget {
   String title='Post';



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
      body: Center(child: RaisedButton(onPressed:() {
        upload();
      },
      child: Text('Pick A Image'),
      )),
      drawer:MyDrawer(),
    );
  }
   void upload() async {
     //pick image   use ImageSource.camera for accessing camera.
     File image = await ImagePicker.pickImage(source: ImageSource.gallery);

     //basename() function will give you the filename
     String fileName =path.basename(image.path);
     var now=new DateTime.now();
     //passing your path with the filename to Firebase Storage Reference
     StorageReference reference =
     FirebaseStorage().ref().child("posts/$now/$fileName");

     //upload the file to Firebase Storage
     StorageUploadTask uploadTask = reference.putFile(image);

     //Snapshot of the uploading task
     StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
     String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
     print('IMAGE:$downloadUrl');
   }

}