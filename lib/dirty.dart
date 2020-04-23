import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_clean/drawer.dart';

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
                          title: document['title'].toString(),
                          image: document['image'],
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
  CustomCard({@required this.name, this.email, this.title, this.description, this.image});
  final name;
  final email;

  final title;
  final description;
  final image;

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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SecondPage(
                                name: name,
                                email: email,
                                title: title,
                                description: description,
                                image: image,
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
  SecondPage({@required this.name, this.email, this.title, this.description, this.image});
  final name;
  final email;

  final title;
  final description;
  final image;

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
          Text("Points: ",
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
          ),
//          Text(points.toString() + "\n",
//            style: TextStyle(fontSize: 30),
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
                      builder: (context) => DirtyScreen(name,email)),
                );
              },
              child: Icon(Icons.map),),
          ),
        ],
      ),
    );
  }

  void updateScore() async{
    try {
      QuerySnapshot querySnapshot = await Firestore.instance.collection(email).
      document("Cleans").collection("Cleans").getDocuments();
      print("list Length");
      print(querySnapshot.documents.length);

      if(querySnapshot.documents.length <= 0){
        //Set new value for points
        databaseReference.collection(email).document('points').setData({
          'points': 0,
        });
      }else {
        print("points exists");
        databaseReference.collection(email).document('points').setData({
          'points': (querySnapshot.documents.length * 10),
        });
      }
    }catch(e){
      print("Error");
    }
  }
}