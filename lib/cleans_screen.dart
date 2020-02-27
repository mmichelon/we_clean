import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_clean/drawer.dart';
class CleansScreen extends StatefulWidget {
  final name;
  final email;
  final items = List<String>.generate(50, (i) => "Item $i");

  CleansScreen(this.name, this.email);
  @override
  State<CleansScreen> createState() => MyCleanScreenState(name, email, items);
}

class MyCleanScreenState extends State<CleansScreen> {
  final name;
  final email;

  final List<String> items;
  final databaseReference = Firestore.instance;

  MyCleanScreenState(this.name, this.email, this.items);

  @override
  Widget build(BuildContext context) {
    final title = 'Long List';
      return Scaffold(
        appBar: AppBar(
          title: Text(name + 's Cleans'),
        ),
        body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  child: Text('Create Record'),
                  onPressed: () {
//                    createRecord();
                  },
                ),
                RaisedButton(
                  child: Text('View Record'),
                  onPressed: () {
                    getData();
                  },
                ),
                RaisedButton(
                  child: Text('Update Record'),
                  onPressed: () {
                    updateData();
                  },
                ),
                RaisedButton(
                  child: Text('Delete Record'),
                  onPressed: () {
                    deleteData();
                  },
                ),
              ],
            )), //center
//        body: ListView.builder(
//          itemCount: items.length,
//          itemBuilder: (context, index) {
//            return ListTile(
//              title: Text('${items[index]}'),
//            );
//          },
//        ),
        drawer: MyDrawer(),
    );
  }

  void getData() {
    databaseReference
        .collection(email)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.documentID} ${f.data}}'));
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
}