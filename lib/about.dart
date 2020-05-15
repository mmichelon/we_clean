import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_clean/drawer.dart';
import 'package:infinite_listview/infinite_listview.dart';

class AboutScreen extends StatefulWidget {
  final name;
  final email;

  AboutScreen(this.name, this.email);
  @override
  State<AboutScreen> createState() => MyAboutScreenState(name, email);
}

class MyAboutScreenState extends State<AboutScreen> {
  final InfiniteScrollController _infiniteController = InfiniteScrollController(
    initialScrollOffset: 0.0,
  );
  final name;
  final email;

  final databaseReference = Firestore.instance;

  MyAboutScreenState(this.name, this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About we_clean'),
      ),
      body: CustomScrollView(
//        primary: false,
        slivers: <Widget>[

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
//              crossAxisSpacing: 10,
//              mainAxisSpacing: 10,
              crossAxisCount: 1,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Text("We_clean Mission statement\n",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,
                        color: Colors.blue),
                      ),
                      Text("This app is used to track personal cleanups and notify other users of dirty locations.\n\n" +
                        "We hope that giving incentive for larger cleans will improve daily habits. Instead of walking past a piece of trash, disposing of it in a trash receptacle",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ]
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                      children: <Widget>[
                        Text("We_clean Expectations and Guidelines:\n",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,
                              color: Colors.blue),
                        ),
                        Text("We_clean users will operate under federal and state laws.\n All users will adhere to Penal codes reguarding illegal dumping and trespassing.\n"+
                          "Users will adhere to all private property rights. "+
                          "Before entering private property, written permission must be abtained before entering the property.",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),

                      ]
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                      children: <Widget>[
                        Text("Disclaimer: \n",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,
                              color: Colors.blue),
                        ),
                        Text("Participating in the use of this app is voluntary. \n"+
                          "By using the software you (the user) accept full liabililty when working or cleaning an area. \n" +
                          "The creators of we_clean are in no way liable for any bodily harm or criminal activity.",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ]
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                      children: <Widget>[
                        Text("Safety Recommendations: \n",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,
                              color: Colors.blue),
                        ),
                        Text("We_clean recommend all users wear proper safety gear including, but not limited to the following.\n",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        Text("Puncture resistant gloves\n" +
                             "Long Sleeve shirt\n" +
                             "Pants\n" +
                             "Ankle height Boots",
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ]
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    drawer: MyDrawer(),
    );
  }
}