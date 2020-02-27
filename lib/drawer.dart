import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:we_clean/new_cleans_screen.dart';
import 'package:we_clean/sign_in.dart';
import 'package:we_clean/cleans_screen.dart';
import 'package:we_clean/home.dart';
import 'package:we_clean/login_page.dart';

class MyDrawer extends StatefulWidget {
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  final databaseReference = Firestore.instance;
  QuerySnapshot querySnapshot;

  void initState() {
    super.initState();
      getDriversList().then((results) {
      setState(() {
        querySnapshot = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  new Text(
                    name +
                        '\'s profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  FutureBuilder( //Used to get score from firebase
                    // This assumes you have a project on Firebase with a firestore database.
                    future: Firestore.instance.collection(email).document("Score").get(),
                    initialData: null,
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if(snapshot.data == null){
                        return CircularProgressIndicator();
                      }
                      DocumentSnapshot doc = snapshot.data;
                      return Text("Score: " + doc.data['Score'].toString(),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('New Cleanup'),
            trailing: Icon(Icons.keyboard_arrow_right),
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
            leading: Icon(Icons.add),
            title: Text('Cleanups'),
            trailing: Icon(Icons.apps),
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
            leading: Icon(Icons.map),
            title: Text('MapView'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: (){
              print('Go to map page');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(name, email)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Sign Out'),
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