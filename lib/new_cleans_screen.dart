import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:we_clean/drawer.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:we_clean/next_new_cleans_screen.dart';

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

  Geoflutterfire geo;
  TextEditingController _latitudeController, _longitudeController;
  Stream<List<DocumentSnapshot>> stream;

  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {'title': null, 'description': null};
  final focusPassword = FocusNode();

  var startTime;

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
      print("_formData");

      print(_formData);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NextNewCleanScreen(name, email, _formData, new DateTime.now(), userLocation.latitude, userLocation.longitude)),
      );
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