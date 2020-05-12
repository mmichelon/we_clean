import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_clean/drawer.dart';

class RewardsScreen extends StatefulWidget {
  final name;
  final email;

  RewardsScreen(this.name, this.email);
  @override
  State<RewardsScreen> createState() => MyRewardsScreenState(name, email);
}

class MyRewardsScreenState extends State<RewardsScreen> {
  final name;
  final email;

  final databaseReference = Firestore.instance;
  double total;

  MyRewardsScreenState(this.name, this.email);
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
                        print(document['redeemed']);
                        if(document['redeemed'] == 0){
                              return new CustomCard(
                                name: name,
                                email: email,
                                title: document['title'].toString(),
                                points: document['points'],
                              );
                            }else{
                          return new CustomCardRedeemed(
                            name: name,
                            email: email,
                            title: document['title'].toString(),
                            points: document['points'],
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
          //If rewards have not been generated make them
          print('${f.data}}');
          databaseReference.collection(email)
              .document('myRewards').collection('myRewards')
              .document(f.data['title'])
              .setData({
            'title': f.data['title'],
            'points': f.data['points'],
            'redeemed': 0
          });
        });
      });
    }
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({@required this.name, this.email, this.title, this.description, this.points});
  final name;
  final email;

  final title;
  final description;
  final points;
  final databaseReference = Firestore.instance;

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
              Firestore.instance
                  .collection(email).document('myRewards').collection("myRewards").document(title)
                  .updateData({
                "redeemed": 1
              }).then((result){
                print("new USer true");
              }).catchError((onError){
                print("onError");
              });
//              databaseReference.collection(email).document('myRewards').collection("myRewards").document(title).setData({
//                'Points': points,
//              });
            },
            ),
          ],
        )
      )
    );
  }
}

class CustomCardRedeemed extends StatelessWidget {
  CustomCardRedeemed({@required this.name, this.email, this.title, this.description, this.points});
  final name;
  final email;

  final title;
  final description;
  final points;

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
//                  onPressed: (){
//
//                  },
                ),
              ],
            )
        )
    );
  }
}
