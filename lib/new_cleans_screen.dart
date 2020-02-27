import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:we_clean/drawer.dart';

import 'package:geolocator/geolocator.dart';


class NewCleanScreen extends StatefulWidget {
  final name;
  final email;

//  final items = List<String>.generate(50, (i) => "Item $i");

  NewCleanScreen(this.name, this.email);
  @override
  State<NewCleanScreen> createState() => MyNewCleanScreenState(name, email);
}

class MyNewCleanScreenState extends State<NewCleanScreen> {
  final name;
  final email;

  final databaseReference = Firestore.instance;

  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {'title': null, 'description': null};
  final focusPassword = FocusNode();

  Geolocator geolocator = Geolocator();
  Position userLocation;

  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation().then((position) {
      userLocation = position;

      print("In New Cleans init");
      print(userLocation);
    });
  }

  MyNewCleanScreenState(this.name, this.email);

  @override
  Widget build(BuildContext context) {
    print("In New Cleans main widget");
    final title = 'Long List';
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
            _buildSubmitButton(),
          ],
        ));
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
        FocusScope.of(context).requestFocus(focusPassword);
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
      child: Text('Start new Clean'),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_formData);
      createRecord(_formData);
    }
  }

  void createRecord(_results) async {
    var _list = _results.values.toList();
    print(_list[0]);
    print(_list[1]);
    print(userLocation.latitude);
    print(userLocation.longitude);

    //Calculate time
    var now = new DateTime.now();
    var sixtyDaysFromNow = now.add(new Duration(days: 60));
    var difference = sixtyDaysFromNow.difference(now);
    print("difference: ");
    print(difference);

    await databaseReference.collection(email) //use email to store collection
        .document(_list[0]) //clean name
        .setData({
      'description': _list[1], //set inner values
      'StartLat': userLocation.latitude,
      'StartLon': userLocation.longitude,
      'StartTime': now
    });
  }

  void deleteData() {
    try {
      databaseReference
          .collection('books')
          .document('1')
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  void getData(value) {
    databaseReference
//        .collection("books")
          .collection(value)

        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  void updateData() {
    try {
      databaseReference
          .collection('books')
          .document('1')
          .updateData({'description': 'Head First Flutter'});
    } catch (e) {
      print(e.toString());
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