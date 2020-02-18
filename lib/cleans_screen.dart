import 'package:flutter/material.dart';

import 'package:we_clean/login_page.dart';
import 'package:we_clean/sign_in.dart';
import 'package:we_clean/home.dart';

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

  MyCleanScreenState(this.name, this.email, this.items);

  @override
  Widget build(BuildContext context) {
    final title = 'Long List';

//    return MaterialApp(
//      title: title,
      return Scaffold(
        appBar: AppBar(
          title: Text(name + 's Cleans'),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${items[index]}'),
            );
          },
        ),
//      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                name +
                    '\'s profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Cleanups'),
              trailing: Icon(Icons.keyboard_arrow_right),
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
              leading: Icon(Icons.account_circle),
              title: Text('email'),
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
      ),
      );
//    );
  }
}