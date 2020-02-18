import 'package:flutter/material.dart';
import 'package:help4real/main.dart';
import 'package:help4real/LoginScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_cropper/image_cropper.dart';

/*
TODO:
1.Add Configuration for iOS for imagePicker
 */

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
         )
     );
     //basename() function will give you the filename
     String fileName =path.basename(croppedFile.path);
     var now=new DateTime.now();
     //passing your path with the filename to Firebase Storage Reference
     StorageReference reference =
     FirebaseStorage().ref().child("posts/$now/$fileName");

     //upload the file to Firebase Storage
     StorageUploadTask uploadTask = reference.putFile(croppedFile);

     //Snapshot of the uploading task
     StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
     String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
     print('IMAGE:$downloadUrl');
   }

}
class PostForm extends StatefulWidget {
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
    final _formkey = GlobalKey<FormState>();
    File _image;
    String caption,tags;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

