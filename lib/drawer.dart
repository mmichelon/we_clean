import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:we_clean/new_cleans_screen.dart';
import 'package:we_clean/sign_in.dart';
import 'package:we_clean/cleans_screen.dart';
import 'package:we_clean/map_screen.dart';
import 'package:we_clean/login_page.dart';
import 'package:we_clean/rewards.dart';
import 'package:we_clean/dirty_screen.dart';
import 'package:we_clean/new_dirty_screen.dart';

//For images
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class MyDrawer extends StatefulWidget {
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  final databaseReference = Firestore.instance;

  QuerySnapshot querySnapshot;
  static const LatLng _center = const LatLng(45.521563, -122.677433);

  File profilePic;
  var downurl;
  double total;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,

      maxHeight: 100,
      maxWidth: 100,
    );

    setState(() {
      profilePic = image;
      print('Image Path $profilePic');
    });
    await uploadPic(image);
  }
  Future uploadPic(_image1) async {
    //Upload the picture to firestore and genereate url
    if (_image1 == null) {
      downurl = "";
    } else {
      print("Uploading profile pic");
      String fileName1 = basename(_image1.path);
      StorageReference firebaseStorageRef1 = FirebaseStorage.instance.ref()
          .child(fileName1);

      StorageUploadTask uploadTask1 = firebaseStorageRef1.putFile(_image1);
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

  // Totals the points from each of the users individual cleans
//  void queryValues() {
//    Firestore.instance
//        .collection(email)
//        .document('Cleans').collection('Cleans')
//        .snapshots()
//        .listen((snapshot) {
//      double tempTotal = snapshot.documents.fold(
//          0, (tot, doc) => tot + doc.data['Points']);
//      setState(() {
//        total = tempTotal;
//      });
//      debugPrint("total.toString()");
//
//      debugPrint(total.toString());
//    });
//  }

  void queryValues() {
    Firestore.instance
        .collection(email)
        .document('Cleans').collection('Cleans')
        .snapshots()
        .listen((snapshot) {
      double tempTotal = snapshot.documents.fold(0, (tot, doc) => tot + doc.data['Points']);
      setState(() {total = tempTotal;});
      debugPrint(total.toString());
    });
  }

  void initState() {
    super.initState();
    getDriversList().then((results) {
      setState(() {
        querySnapshot = results;
      });
    });
    queryValues();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
          UserAccountsDrawerHeader(
          accountName:
            Text(
              "Points: " + total.toStringAsFixed(5),
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 18,
              ),
            ),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
                child: FutureBuilder( //Used to get points from firebase
                  // This assumes you have a project on Firebase with a firestore database.
                    future: Firestore.instance.collection(email).document("Profile_Pic").get(),
                    initialData: null,
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if(snapshot.data == null){
                        return CircularProgressIndicator();
                      }
                      DocumentSnapshot doc = snapshot.data;
                      return ClipOval(
                        child: Image.network(
                          doc.data['Profile_Pic'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                ),
            ),
            otherAccountsPictures: <Widget>[
              new RawMaterialButton(
                onPressed: () {
                  getImage();
                },
                child: new Icon(
                  Icons.file_upload,
                  color: Colors.blue,
//                  size: 35.0,
                ),
                shape: new CircleBorder(),
                fillColor: Colors.white,
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Cleanups',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
            ),
            children: <Widget>[
            ListTile(
              trailing: Icon(Icons.add),
              title: Text('      New Cleanup'),
              onTap: (){
                print('Go to new cleanup page');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewCleanScreen(name, email)),
                );
              },
            ),
            ListTile(
              trailing: Icon(Icons.apps),
              title: Text('      Cleanups'),
              onTap: (){
                print('Go to cleanups page');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CleansScreen(name, email)),
                );
              },
            ),
          ListTile(
            trailing: Icon(Icons.map),
            title: Text('      MapView'),
            onTap: (){
              print('Go to map page');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapScreen(name, email, 45.521563, -122.677433 )),
              );
            },
          ),
            ],
          ),
          ExpansionTile(
            title: Text('Dirty Locations',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
            ),
            children: <Widget>[
              ListTile(
                trailing: Icon(Icons.add),
                title: Text('      New Dirty Location'),
                onTap: (){
                  print('Go to new New Dirty page');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewDirtyScreen(name, email)),
                  );
                },
              ),
              ListTile(
                trailing: Icon(Icons.error),
                title: Text('      Dirty Locations'),
                onTap: (){
                  print('Go to dirty locations');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DirtyScreen(name, email)),
                  );
                },
              ),

            ],
          ),
          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('Rewards',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
            ),
            onTap: (){
              print('Go to map page');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RewardsScreen(name, email)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Sign Out',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
            ),
            onTap: (){
              signOutGoogle();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    );

  }
  Future getDriversList() async {
    return await Firestore.instance.collection(email).getDocuments();
  }
}