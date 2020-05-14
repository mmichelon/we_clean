import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_clean/drawer.dart';
import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';


class RewardsScreen extends StatefulWidget {
  final name;
  final email;
  final userTotal;
  RewardsScreen(this.name, this.email, this.userTotal);
  @override
  State<RewardsScreen> createState() => MyRewardsScreenState(name, email, userTotal);
}

class MyRewardsScreenState extends State<RewardsScreen> {
  final name;
  final email;
  final userTotal;

  final databaseReference = Firestore.instance;
  double total;

  MyRewardsScreenState(this.name, this.email, this.userTotal);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards'),
      ),

      body: Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection(email).document('myRewards').collection('myRewards').snapshots(),
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
                        //need to change to check if it has been redeamed or not
                        //Return different custom card if so
                        if(document['redeemed'] == 0){
                              return new CustomCard(
                                name: name,
                                email: email,
                                title: document['title'].toString(),
                                points: document['points'],
                                userTotal: userTotal,
                              );
                            }else{
                          return new CustomCardRedeemed(
                            name: name,
                            email: email,
                            title: document['title'].toString(),
                            points: document['points'],
                            code: document['code'],
                          );
                        }
                      }).toList(),
                    );
                }
              },
            )),
      ),
      drawer: MyDrawer(),
    );
  }

  void queryValues() async{
    QuerySnapshot querySnapshot = await Firestore.instance.collection(email).document('myRewards').collection('myRewards').getDocuments();
    Random random = new Random();

    print("list Length");
//    print(querySnapshot.documents.length);
    int rewardCount = querySnapshot.documents.length;

    if(rewardCount != 4) {
      //add new enteries if they dont exist
      databaseReference
          .collection("Rewards")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          int randomNumber = random.nextInt(9000) + 1000; // from 10 upto 99 included
          //If rewards have not been generated make them
          print('${f.data}}');
          databaseReference.collection(email)
              .document('myRewards').collection('myRewards')
              .document(f.data['title'])
              .setData({
            'title': f.data['title'],
            'points': f.data['points'],
            'redeemed': 0,
            'code': randomNumber,
          });
        });
      });
    }
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({@required this.name, this.email, this.title, this.description, this.points, this.userTotal});
  final name;
  final email;

  final title;
  final description;
  final points;
  final userTotal;

  final databaseReference = Firestore.instance;

  double total;

  double tempTotal;

  void showLongToast() {
    Fluttertoast.showToast(
      msg: "Not Enough Points",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
//      color: Colors.green,
      child: Container(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          children: <Widget>[
          Text(title,
            style: TextStyle(fontSize: 24),
          ),
          Text("Points: " + points.toString(),
            style: TextStyle(fontSize: 24, color: Colors.purple),
          ),
          FlatButton(
            child: Text("Redeem"),
            onPressed: (){
              print("userTotal: " + userTotal.toString());
              print("points: " + points.toString());
              if(userTotal > points) {
                Firestore.instance
                    .collection(email).document('myRewards').collection(
                    "myRewards").document(title)
                    .updateData({
                  "redeemed": 1,
                }).then((result) {
                  print("new User true");
                }).catchError((onError) {
                  print("onError");
                });
              }else{
                showLongToast();
                print("Not enough points");
              }
            },
            ),
          ],
        )
      )
    );
  }
}

class CustomCardRedeemed extends StatelessWidget {
  CustomCardRedeemed({@required this.name, this.email, this.title, this.description, this.points, this.code});
  final name;
  final email;

  final title;
  final description;
  final points;
  final code;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.green,
        child: Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: <Widget>[
                Text(title,
                  style: TextStyle(fontSize: 24),
                ),
                Text("Points: " + points.toString(),
                  style: TextStyle(fontSize: 24, color: Colors.purple),
                ),
                FlatButton(
                  child: Text("Redeemed"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SecondPage(
                                name: name,
                                email: email,
                                title: title,
                                points: points,
                                code: code,
                              )));
                    }
                ),
              ],
            )
        )
    );
  }
}


class SecondPage extends StatelessWidget {
  SecondPage({@required this.name, this.email, this.title, this.points, this.code});
  final name;
  final email;

  final title;
  final points;
  final code;

  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
//      body: CustomScrollView(
//        primary: false,
    body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("\n"),
                Container(
                  child: Column(
                    children: <Widget>[
                    Text("Points: ",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
                    ),
                    Text(points.toString() + "\n",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
                    ),
//                    Text("Terrain: \n" + terrain.toString() + "\n"),
//                    Text("Density: \n" + density.toString() + "\n"),
                  ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                    Text("Code to redeem: ",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
                    ),
                    Text(code.toString() + "\n",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
                    ),
//                    Text("Terrain: \n" + terrain.toString() + "\n"),
//                    Text("Density: \n" + density.toString() + "\n"),
                  ],
                  ),
                ),
//              Expanded(
//                child: FittedBox(
//                  fit: BoxFit.contain, // otherwise the logo will be tiny
//                  child: const FlutterLogo(),
//                ),
//              ),
            ],
          ),
      ),
    );
  }
}