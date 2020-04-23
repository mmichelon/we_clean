import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:we_clean/drawer.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:we_clean/dirty_screen.dart';

//For images
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class NewDirtyScreen extends StatefulWidget {
  final name;
  final email;

//  final items = List<String>.generate(50, (i) => "Item $i");

  NewDirtyScreen(this.name, this.email);
  @override
  State<NewDirtyScreen> createState() => MyNewDirtyScreenState(name, email);
}

class MyNewDirtyScreenState extends State<NewDirtyScreen> {
  final name;
  final email;

  final databaseReference = Firestore.instance;
  QuerySnapshot querySnapshot;

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {'title': null, 'description': null};
  final focusPassword = FocusNode();

  Geolocator geolocator = Geolocator();
  Position userLocation;

  var startLat;
  var startLon;
  var downurl;

  File dirtyPic;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 500,
    );

    setState(() {
      dirtyPic = image;
      print('Image Path $dirtyPic');
    });
    await uploadPic(dirtyPic);
  }

  Future uploadPic(_image) async {
    //Upload the picture to firestore and genereate url
    if (_image == null) {
      downurl = "";
    } else {
      print("Uploading profile pic");
      String fileName1 = basename(_image.path);
      StorageReference firebaseStorageRef1 = FirebaseStorage.instance.ref()
          .child(fileName1);

      StorageUploadTask uploadTask1 = firebaseStorageRef1.putFile(_image);
      downurl = await (await uploadTask1.onComplete).ref.getDownloadURL();
      print("downurl");
      print(downurl);
    }
    //add it to their database entry
    try {
      databaseReference
          .collection(email)
          .document('Profile_Pic')
          .setData({
        'Profile_Pic': downurl,
//        'Difference' : difference
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation().then((position) {
      userLocation = position;

      print("In Dirty init");
      print(userLocation);
    });
  }

  MyNewDirtyScreenState(this.name, this.email);

  @override
  Widget build(BuildContext context) {
    print("In New Cleans main widget");
    return Scaffold(
      appBar: AppBar(
        title: Text(name + 's Cleans'),
      ),
      body: _buildForm(),
      drawer: MyDrawer(),
    );
  }
  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildEmailField(),
            _buildPasswordField(),
            Container(
              padding: const EdgeInsets.all(8),
              child: dirtyPic == null
              //                    ? Text('No image selected.')
                  ? RaisedButton(
                onPressed: getImage,
                child: const Text(
                    'Image of area before 1',
                    style: TextStyle(fontSize: 20)
                ),
              )
                  : Image.file(dirtyPic, height: 400, width: 400),
              //                    color: Colors.green[100],
            ),
            _buildSubmitButton(),
          ],
        )
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Title'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Enter a valid title';
        }
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(this.context).requestFocus(focusPassword);
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Description'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Enter a valid description.';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
      focusNode: focusPassword,
      onFieldSubmitted: (v) {
        _submitForm();

      },
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: () {
        _submitForm();
      },
      child: Text('Post Dirty Location'),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("_formData");

      print(_formData);

      _endDirty();
      Navigator.push(
        this.context,
        MaterialPageRoute(
            builder: (context) => DirtyScreen(name, email)),
      );
    }
  }

  Future _endDirty() async {
    //Wait for images to be posted to firebase
//    await uploadPic(dirtyPic,downurl);

    await _endRecord(_formData,downurl);
  }

  Future _endRecord(_results, downurl) async {
    var _list = _results.values.toList();

    print("downurl");
    print(downurl);

    try {
      databaseReference
          .collection('Dirty')
          .document(_list[0])
          .setData({
            'title': _list[0],
            'description': _list[1], //set inner values
            'startLat': userLocation.latitude,
            'startLon': userLocation.longitude,
            'downurl': downurl,
            'poster': name,
            'posterEmail': email,
          });
    } catch (e) {
      print(e.toString());
    }
//    updateScore();
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

}