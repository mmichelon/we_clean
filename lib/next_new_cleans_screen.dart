import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:we_clean/drawer.dart';

import 'package:geolocator/geolocator.dart';

//import 'package:we_clean/new_cleans_screen.dart';

class NextNewCleanScreen extends StatefulWidget {
  final name;
  final email;
  final _formData;
  final startTime;
//  final items = List<String>.generate(50, (i) => "Item $i");

  NextNewCleanScreen(this.name, this.email, this._formData, this.startTime);
  @override
  State<NextNewCleanScreen> createState() => MyNextNewCleanScreenState(name, email, _formData, startTime);
}

class MyNextNewCleanScreenState extends State<NextNewCleanScreen> {
  final name;
  final email;
  final _formData;
  final startTime;

  var _list;

  final databaseReference = Firestore.instance;
//  QuerySnapshot querySnapshot;

//  final _formKey = GlobalKey<FormState>();

//  final Map<String, dynamic> _formData = {'title': null, 'description': null};
  final focusPassword = FocusNode();

  Geolocator geolocator = Geolocator();
  Position userLocation;

  void initState() {
    // TODO: implement initState
    super.initState();
    _list = _formData.values.toList();

    _getLocation().then((position) {
      userLocation = position;

      print("In Next New Cleans init");
      print(userLocation);
    });

//    Firestore.instance.collection(email).getDocuments().then((results) {
//      setState(() {
//        querySnapshot = results;
//      });
//    });
  }

  MyNextNewCleanScreenState(this.name, this.email, this._formData, this.startTime);

  @override
  Widget build(BuildContext context) {
    print("In Next New Cleans main widget");
    print(_list[1]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Clean: '+_list[0]),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text("Description: " + _list[1]),
            _buildSubmitButton()
          ],
        ),
      ),
//      body: _buildSubmitButton(),
      drawer: MyDrawer(),
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: () {
        _endClean();
      },
      child: Text('End current Clean'),
    );
  }

  void _endClean() {
      endRecord(_formData);
  }

  void endRecord(_results) async {
    var _list = _results.values.toList();

    final String _collection = email;
    final Firestore _fireStore = Firestore.instance;

    print(_list[0]);
    print(_list[1]);
    print(userLocation.latitude);
    print(userLocation.longitude);

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
          .document(_list[0])
          .updateData({
        'EndLat': userLocation.latitude,
        'EndLon': userLocation.longitude,
        'EndTime': now,
//        'Difference' : difference
      });
    } catch (e) {
      print(e.toString());
    }
    updateScore();
  }

  void updateScore() async {
    Firestore.instance.
    collection(email).
    document('Score').
    updateData(<String, dynamic> {
      'Score': FieldValue.increment(10),
    });
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