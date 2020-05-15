import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_clean/drawer.dart';
import 'package:we_clean/map_clean_screen.dart';

class CleansScreen extends StatefulWidget {
  final name;
  final email;

  CleansScreen(this.name, this.email);
  @override
  State<CleansScreen> createState() => MyCleanScreenState(name, email);
}

class MyCleanScreenState extends State<CleansScreen> {
  final name;
  final email;

  final databaseReference = Firestore.instance;

  MyCleanScreenState(this.name, this.email);

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
                              EndLat: document['EndLat'],
                              EndLon: document['EndLon'],
                              StartTime: document['StartTime'],
                              EndTime: document['EndTime'],
                              downurl1: document['downurl1'],
                              downurl2: document['downurl2'],
                              downurl3: document['downurl3'],
                              downurl4: document['downurl4'],
                              terrain: document['terrain'],
                              density: document['density'],
                              Points: document['Points'],
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
  CustomCard({@required this.name, this.email, this.title, this.description, this.StartLat, this.StartLon, this.EndLat, this.EndLon,
    this.StartTime, this.EndTime, this.downurl1, this.downurl2, this.downurl3, this.downurl4, this.terrain, this.density,this.Points});
  final name;
  final email;

  final title;
  final description;

  final StartLat;
  final StartLon;
  final EndLat;
  final EndLon;

  final StartTime;
  final EndTime;

  final downurl1;
  final downurl2;
  final downurl3;
  final downurl4;

  final terrain;
  final density;
  final Points;
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
                                  EndLat: EndLat,
                                  EndLon: EndLon,
                                  StartTime: StartTime,
                                  EndTime: EndTime,
                                  downurl1: downurl1,
                                  downurl2: downurl2,
                                  downurl3: downurl3,
                                  downurl4: downurl4,
                                  terrain: terrain,
                                  density: density,
                                  Points: Points,
                              )));
                    }
                    ),
              ],
            )));
  }
}

class SecondPage extends StatelessWidget {
  SecondPage({@required this.name, this.email, this.title, this.description, this.StartLat, this.StartLon, this.EndLat, this.EndLon,
    this.StartTime, this.EndTime, this.downurl1, this.downurl2, this.downurl3, this.downurl4, this.terrain, this.density, this.Points});
  final name;
  final email;

  final title;
  final description;

  final StartLat;
  final StartLon;
  final EndLat;
  final EndLon;

  final StartTime;
  final EndTime;

  final downurl1;
  final downurl2;
  final downurl3;
  final downurl4;

  final terrain;
  final density;
  final Points;

  final databaseReference = Firestore.instance;

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
              Container(
                child: Column(children: <Widget>[
                  Text("Description:",style: TextStyle(color: Colors.blue),),
                  Text(description.toString()+ "\n",
                    textAlign: TextAlign.center,),
                  Text("Terrain:",style: TextStyle(color: Colors.blue),),
                  Text(terrain.toString()),
                  Text("Density:",style: TextStyle(color: Colors.blue),),
                  Text(density.toString()),

                ],
              ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(children: <Widget>[
                Text("Time Spent:",style: TextStyle(color: Colors.blue),),
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
                Text("\n Points",style: TextStyle(color: Colors.blue),),
                Text(Points.toStringAsFixed(5) + "\n"),

                ],
                )
              ),

              ],
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 50,
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(8),
                child: Text("Images Before:",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                  textAlign: TextAlign.center,
                )
              ),

            ],
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 450,
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(8),
                child: downurl1 == ""
                  ? Text("No image")
                  : Image.network(downurl1, fit:BoxFit.fill),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: downurl2 == ""
                    ? Text("No image")
                    : Image.network(downurl2, fit:BoxFit.fill),
              ),
            ],
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 50,
            delegate: SliverChildListDelegate([
              Container(
                  padding: const EdgeInsets.all(8),
                  child: Text("Images After:",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                    textAlign: TextAlign.center,
                  )
              ),

            ],
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 450,
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(8),
                child: downurl3 == ""
                    ? Text("No image")
                    : Image.network(downurl3, fit:BoxFit.fill),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: downurl4 == ""
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
//            padding: EdgeInsets.all(10.0),
            alignment: Alignment.bottomLeft,

            child: Container(
            padding: const EdgeInsets.only(left: 30.0),
            child: FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                deleteClean(title);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CleansScreen(name,email)),
                );
              },
              child: Icon(Icons.delete),
            ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapCleanScreen(name, email, StartLat, StartLon, EndLat, EndLon, title, description)),
                );
              },
              child: Icon(Icons.map),),
          ),
        ],
      ),
    );
  }
  void deleteClean(curDocument) {
    try {
      databaseReference
          .collection(email)
          .document('Cleans')
          .collection('Cleans')
          .document(curDocument)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }
}