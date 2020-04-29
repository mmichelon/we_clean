import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_clean/drawer.dart';

import 'package:we_clean/map_dirty_screen.dart';

class DirtyScreen extends StatefulWidget {
  final name;
  final email;

  DirtyScreen(this.name, this.email);
  @override
  State<DirtyScreen> createState() => MyDirtyScreenState(name, email);
}

class MyDirtyScreenState extends State<DirtyScreen> {
  final name;
  final email;

  final databaseReference = Firestore.instance;

  MyDirtyScreenState(this.name, this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dirty Locations'),
      ),

      body: Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('Dirty')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return new ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document){
                        return new CustomCard(
                          name: name,
                          email: email,
                          StartLat: document['startLat'],
                          StartLon: document['startLon'],
                          title: document['title'].toString(),
                          description: document['description'].toString(),
                          downurl: document['downurl'].toString(),
                        );
                      }).toList(),
                    );
                }
              },
            )),
      ),
      drawer: MyDrawer(),
    );
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({@required this.name, this.email, this.StartLat, this.StartLon, this.title, this.description, this.downurl});
  final name;
  final email;
  final StartLat;
  final StartLon;
  final title;
  final description;
  final downurl;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: <Widget>[
                Text(title,
                  style: TextStyle(fontSize: 24),
                ),
//                Text("Points: " + points.toString(),
//                  style: TextStyle(fontSize: 24, color: Colors.purple),
//                ),
                FlatButton(
                    child: Text("See More"),
                    onPressed: () {

                      print("StartLat and StartLon");
                      print(StartLat);
                      print(StartLon);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SecondPage(
                                name: name,
                                email: email,
                                title: title,
                                StartLat: StartLat,
                                StartLon: StartLon,
                                description: description,
                                downurl: downurl,
                              )
                          )
                      );

                    }),
              ],
            )
        )
    );
  }
}

class SecondPage extends StatelessWidget {
  SecondPage({@required this.name, this.email, this.title, this.StartLat, this.StartLon, this.description, this.downurl});
  final name;
  final email;
  final StartLat;
  final StartLon;
  final title;
  final description;

  final downurl;

  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(name + " requests your help!",
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
          ),
          Text(""), //Spacer
          Text(description.toString(),
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            child: downurl == ""
                ? Text("No image")
                : Image.network(downurl, fit:BoxFit.fill),
          ),

//          Image.network(
//            downurl,
//            width: 400,
//            height: 400,
//            fit: BoxFit.cover,
//          ),
        ],
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapDirtyScreen(name, email, StartLat, StartLon, title, description)),

//                      builder: (context) => map(name,email)),
                );
              },
              child: Icon(Icons.map),),
          ),
        ],
      ),
    );
  }
}