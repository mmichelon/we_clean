import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:we_clean/drawer.dart';

import 'package:geolocator/geolocator.dart';

import 'package:we_clean/cleans_screen.dart';

//For images
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';


class NextNewCleanScreen extends StatefulWidget {
  final name;
  final email;
  final _formData;
  final startTime;
  final StartLat;
  final StartLon;
//  final items = List<String>.generate(50, (i) => "Item $i");

  NextNewCleanScreen(this.name, this.email, this._formData, this.startTime, this.StartLat, this.StartLon);
  @override
  State<NextNewCleanScreen> createState() => MyNextNewCleanScreenState(name, email, _formData, startTime, StartLat, StartLon);
}

class MyNextNewCleanScreenState extends State<NextNewCleanScreen> {
  final name;
  final email;
  final _formData;
  final startTime;

  final StartLat;
  final StartLon;

  var _list;
  final databaseReference = Firestore.instance;
//  QuerySnapshot querySnapshot;

//  final _formKey = GlobalKey<FormState>();

//  final Map<String, dynamic> _formData = {'title': null, 'description': null};
  final focusPassword = FocusNode();

  Geolocator geolocator = Geolocator();
  Position userLocation;

  //for images
//  File _image;
//  String _uploadedFileURL;
  File _image1;
  File _image2;
  File _image3;
  File _image4;

  var downurl1;
  var downurl2;
  var downurl3;
  var downurl4;


  Future getImage1() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image1 = image;
      print('Image Path $_image1');
    });
  }
  Future getImage2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image2 = image;
      print('Image Path $_image2');

    });
  }
  Future getImage3() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image3 = image;
      print('Image Path $_image3');
    });
  }
  Future getImage4() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image4 = image;
      print('Image Path $_image4');
    });
  }

  Future uploadPic(_image1, _image2, _image3, _image4) async{
    if(_image1 == null) {
      downurl1 = "";
    }else{
      print("Uploading Pic 1");
      String fileName1 = basename(_image1.path);
      StorageReference firebaseStorageRef1 = FirebaseStorage.instance.ref()
          .child(fileName1);

      StorageUploadTask uploadTask1 = firebaseStorageRef1.putFile(_image1);
      downurl1 = await (await uploadTask1.onComplete).ref.getDownloadURL();
      print("downurl1");
      print(downurl1);
    }
    //////////////////////////////
    if(_image2 == null) {
      downurl2 = "";
    }else{
      print("Uploading Pic 2");
    String fileName2 = basename(_image2.path);
    StorageReference firebaseStorageRef2 = FirebaseStorage.instance.ref().child(fileName2);

    StorageUploadTask uploadTask2 = firebaseStorageRef2.putFile(_image2);
    downurl2 = await (await uploadTask2.onComplete).ref.getDownloadURL();
    print("downur2");
    print(downurl2);

  }
    //////////////////////////////
    if(_image3 == null) {
      downurl3 = "";
    }else{
      print("Uploading Pic 3");
    String fileName3 = basename(_image3.path);
    StorageReference firebaseStorageRef3 = FirebaseStorage.instance.ref().child(fileName3);

    StorageUploadTask uploadTask3 = firebaseStorageRef3.putFile(_image3);
    downurl3 = await (await uploadTask3.onComplete).ref.getDownloadURL();
    print("downurl3");
    print(downurl3);
}
    //////////////////////////////
    if(_image4 == null) {
      downurl4 = "";
    }else{
      print("Uploading Pic 4");
    String fileName4 = basename(_image4.path);
    StorageReference firebaseStorageRef4 = FirebaseStorage.instance.ref().child(fileName4);

    StorageUploadTask uploadTask4 = firebaseStorageRef4.putFile(_image4);
    downurl4 = await (await uploadTask4.onComplete).ref.getDownloadURL();
    print("downurl4");
    print(downurl4);
}
//    StorageTaskSnapshot taskSnapshot=await uploadTask1.onComplete;
//    setState(() {
//      print("Profile Picture uploaded");
////      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
//    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _list = _formData.values.toList();

    _getLocation().then((position) {
      userLocation = position;

      print("In Next New Cleans init");
      print(userLocation);
    });
  }

  MyNextNewCleanScreenState(this.name, this.email, this._formData, this.startTime, this.StartLat, this.StartLon);

  @override
  Widget build(BuildContext context) {
    print("In Next New Cleans main widget");
    print(_list[1]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Clean: '+_list[0]),
      ),

      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  child: _image1 == null
//                    ? Text('No image selected.')
                    ? RaisedButton(
                    onPressed: getImage1,
                    child: const Text(
                        'Image of area before 1',
                        style: TextStyle(fontSize: 20)
                    ),
                  )
                  : Image.file(_image1, height: 200, width: 200),
//                    color: Colors.green[100],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: _image2 == null
                      ? RaisedButton(
                    onPressed: getImage2,
                    child: const Text(
                        'Image of area before 2',
                        style: TextStyle(fontSize: 20)
                    ),
                  )
                      : Image.file(_image2, height: 200, width: 200),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: _image3 == null
                      ? RaisedButton(
                    onPressed: getImage3,
                    child: const Text(
                        'Image of area after 3',
                        style: TextStyle(fontSize: 20)
                    ),
                  )
                      : Image.file(_image3, height: 200, width: 200),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: _image4 == null
                      ? RaisedButton(
                    onPressed: getImage4,
                    child: const Text(
                        'Image of area after 4',
                        style: TextStyle(fontSize: 20)
                    ),
                  )
                      : Image.file(_image4, height: 200, width: 200),
                ),
              ],
            ),
          ),
        ],
      ),
//        child: _image == null
//            ? Text('No image selected.')
//            : Image.file(_image, height: 200, width: 200),
//      ),

        floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: "btn2",
                onPressed: () {
//                  uploadPic(context);
                  _endClean();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CleansScreen(name, email)),
                  );
//                  endRecord(_formData);
                  print("Down URLS Exit");
                  print(downurl1);
                  print(downurl2);
                  print(downurl3);
                  print(downurl4);
                },
                child: Icon(Icons.check_circle),),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                heroTag: "btn3",
                onPressed: () {
                  uploadPic(_image1, _image2, _image3, _image4);
                  print("Download URLS");
                  print(downurl1);
                  print(downurl2);
                  print(downurl3);
                  print(downurl4);
                },
                child: Icon(Icons.cake),),
            ),

          ],
        ),

//      body: _buildSubmitButton(),
      drawer: MyDrawer(),
    );
  }

//  void _endClean() {
  Future _endClean() async {
    //Wait for images to be posted to firebase
    await uploadPic(_image1, _image2, _image3, _image4);

    print("Before wait");
    print("After wait");
    await endRecord(_formData);
  }

  Future endRecord(_results) async {
    var _list = _results.values.toList();

    print(_list[0]);
    print(_list[1]);
    print(userLocation.latitude);
    print(userLocation.longitude);

    print("Download URLS");
    print(downurl1);
    print(downurl2);
    print(downurl3);
    print(downurl4);
    //Calculate time
    var now = new DateTime.now();
    var difference;

    difference = now.difference(startTime);

    print("difference seconds");
    print(difference.inSeconds);
    print("difference: ");
    print(difference);

    print("startTime: ");
    print(startTime);

    try {
      databaseReference
          .collection(email)
          .document('Cleans').collection('Cleans')
          .document(_list[0])
          .setData({
        'title': _list[0],
        'description': _list[1], //set inner values
        'StartLat': StartLat,
        'StartLon': StartLon,
        'StartTime': startTime,

        'EndLat': userLocation.latitude,
        'EndLon': userLocation.longitude,
        'EndTime': now,

        'downurl1': downurl1,
        'downurl2': downurl2,
        'downurl3': downurl3,
        'downurl4': downurl4
//        'Difference' : difference
      });
    } catch (e) {
      print(e.toString());
    }
    updateScore();
  }
  void updateScore() async{
    try {
      QuerySnapshot querySnapshot = await Firestore.instance.collection(email).
      document("Cleans").collection("Cleans").getDocuments();
      print("list Length");
      print(querySnapshot.documents.length);

      if(querySnapshot.documents.length <= 0){
        //Set new value for points
        databaseReference.collection(email).document('Points').setData({
          'Points': 0,
        });
      }else {
        print("Points exists");
        databaseReference.collection(email).document('Points').setData({
          'Points': (querySnapshot.documents.length * 10),
        });
      }
    }catch(e){
      print("Error");
    }
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