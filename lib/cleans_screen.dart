import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_clean/drawer.dart';
import 'package:we_clean/map_screen.dart';

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
//    final title = 'Long List';
      return Scaffold(
        appBar: AppBar(
          title: Text(name + '\'s Cleans'),
        ),

        body: Center(
          child: Container(
              padding: const EdgeInsets.all(10.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection(email)
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
                              title: document['title'].toString(),
                              description: document['description'],
                              StartLat: document['StartLat'],
                              StartLon: document['StartLon'],
                              StartTime: document['StartTime'],
                              EndTime: document['EndTime'],
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
  CustomCard({@required this.name, this.email, this.title, this.description, this.StartLat, this.StartLon, this.StartTime, this.EndTime});
  final name;
  final email;

  final title;
  final description;

  final StartLat;
  final StartLon;

  final StartTime;
  final EndTime;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: <Widget>[
                Text(title),
                FlatButton(
                    child: Text("See More"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SecondPage(
                                  name: name,
                                  email: email,
                                  title: title,
                                  description: description,
                                  StartLat: StartLat,
                                  StartLon: StartLon,
                                  StartTime: StartTime,
                                  EndTime: EndTime
                              )));
                    }),
              ],
            )));
  }
}

class SecondPage extends StatelessWidget {
  SecondPage({@required this.name, this.email, this.title, this.description, this.StartLat, this.StartLon, this.StartTime, this.EndTime});
  final name;
  final email;

  final title;
  final description;

  final StartLat;
  final StartLon;

  final StartTime;
  final EndTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Description: "),
                Text(description.toString() + "\n"),
//                Text(StartLat.toString()),
//                Text(StartLon.toString()),
                Text("Time Spent:"),
                Text(DateTime.fromMillisecondsSinceEpoch(EndTime.seconds*1000)
                    .difference(DateTime.fromMillisecondsSinceEpoch(StartTime.seconds*1000))
                    .inHours
                    .toString() +
                    " hours and " +
                    DateTime.fromMillisecondsSinceEpoch(EndTime.seconds*1000)
                    .difference(DateTime.fromMillisecondsSinceEpoch(StartTime.seconds*1000))
                    .inSeconds
                    .toString() +
                    " Seconds"),
//                Text(DateTime.fromMillisecondsSinceEpoch(StartTime.seconds*1000).toString()),
//                Text(DateTime.fromMillisecondsSinceEpoch(EndTime.seconds*1000).toString()),
                RaisedButton(
                    child: Text('Back To Cleans Screen'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () => Navigator.pop(context)),
                RaisedButton(
                    child: Text('Open on Map'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: (){
                      print('Go to map page');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapScreen(name, email, StartLat, StartLon)),
                      );
                    },
//                    onPressed: () => Navigator.pop(context)
                ),
              ]),
        ));
  }
}