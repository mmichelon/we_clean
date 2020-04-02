import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_clean/drawer.dart';
import 'package:we_clean/map_clean_screen.dart';

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
      return Scaffold(
        appBar: AppBar(
          title: Text(name + '\'s Cleans'),
        ),

        body: Center(
          child: Container(
              padding: const EdgeInsets.all(10.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection(email)
                    .document('Cleans').collection('Cleans')

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
                              downurl1: document['downurl1'],
                              downurl2: document['downurl2'],
                              downurl3: document['downurl3'],
                              downurl4: document['downurl4'],
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
  CustomCard({@required this.name, this.email, this.title, this.description, this.StartLat, this.StartLon, this.StartTime, this.EndTime,
    this.downurl1, this.downurl2, this.downurl3, this.downurl4});
  final name;
  final email;

  final title;
  final description;

  final StartLat;
  final StartLon;

  final StartTime;
  final EndTime;

  final downurl1;
  final downurl2;
  final downurl3;
  final downurl4;

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
                                  EndTime: EndTime,
                                  downurl1: downurl1,
                                  downurl2: downurl2,
                                  downurl3: downurl3,
                                  downurl4: downurl4,


                              )));
                    }),
              ],
            )));
  }
}

class SecondPage extends StatelessWidget {
  SecondPage({@required this.name, this.email, this.title, this.description, this.StartLat, this.StartLon, this.StartTime, this.EndTime,
        this.downurl1, this.downurl2, this.downurl3, this.downurl4});
  final name;
  final email;

  final title;
  final description;

  final StartLat;
  final StartLon;

  final StartTime;
  final EndTime;

  final downurl1;
  final downurl2;
  final downurl3;
  final downurl4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
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
//                Container(
//                  padding: const EdgeInsets.all(8),
//                  child: downurl1 == null
//                      ? Text("No image")
//                      : Image.network(downurl1, fit:BoxFit.fill),
////                    color: Colors.green[100],
//                ),
              Container(
                child: Column(children: <Widget>[
                  Text("Description: "),
                  Text(description.toString() + "\n"),
                ],
              ),

              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(children: <Widget>[
                Text("Time Spent:"),
                Text(StartTime == null || EndTime == null
                        ? Text("No Time")
                        : DateTime.fromMillisecondsSinceEpoch(EndTime.seconds*1000)
                    .difference(DateTime.fromMillisecondsSinceEpoch(StartTime.seconds*1000))
                    .inHours
                    .toString() +
                    " hours"
                    ),
                Text(StartTime == null || EndTime == null
                    ? Text("No Time")
                    : DateTime.fromMillisecondsSinceEpoch(EndTime.seconds*1000)
                    .difference(DateTime.fromMillisecondsSinceEpoch(StartTime.seconds*1000))
                    .inMinutes
                    .toString() +
                    " Minutes"),
                Text(StartTime == null || EndTime == null
                    ? Text("No Time")
                    : (DateTime.fromMillisecondsSinceEpoch(EndTime.seconds*1000)
                    .difference(DateTime.fromMillisecondsSinceEpoch(StartTime.seconds*1000))
                    .inSeconds % 60)
                    .toString() +
                    " Seconds"),
                  ],
                )
              ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: downurl1 == null
                      ? Text("No image")
                      : Image.network(downurl1, fit:BoxFit.fill),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: downurl2 == null
                      ? Text("No image")
                      : Image.network(downurl2, fit:BoxFit.fill),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: downurl3 == null
                      ? Text("No image")
                      : Image.network(downurl3, fit:BoxFit.fill),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: downurl4 == null
                      ? Text("No image")
                      : Image.network(downurl4, fit:BoxFit.fill),
                ),
              ],
            ),
          ),
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
                      builder: (context) => MapCleanScreen(name, email, StartLat, StartLon, title, description)),
                );        },
              child: Icon(Icons.map),),
          ),
        ],
      ),
    );
  }
}