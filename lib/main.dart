import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'We.Clean',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if (user == null) {
            return SignInPage();
          }
          return HomePage();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class SignInPage extends StatelessWidget {

  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('We.Clean')),
      body: Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new RaisedButton(
            padding: const EdgeInsets.all(8.0),
            textColor: Colors.white,
            color: Colors.blue,
            onPressed: _signInAnonymously,
            child: new Text("Sign in anonymously"),
          ),
          new RaisedButton(
//            onPressed: _signInAnonymously,
            textColor: Colors.white,
            color: Colors.red,
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Sign in with Email",
            ),
          ),
        ],
      )
      ),
    );
  }
}

class HomePage extends StatelessWidget {

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: _signOut,
          ),
        ],
      ),

      body: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Hello ', style: TextStyle(fontSize: 30, color: Colors.orangeAccent)),
                    TextSpan(text: 'Anonymous', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue)),
                    TextSpan(text: ' user!', style: TextStyle(fontSize: 30, color: Colors.orangeAccent)),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}


////Test code for app baseline - test dependencies

//import 'package:flutter/material.dart';
//
//void main() => runApp(MyApp());
//
///// This Widget is the main application widget.
//class MyApp extends StatelessWidget {
//  static const String _title = 'Flutter Code Sample';
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: _title,
//      home: MyStatefulWidget(),
//    );
//  }
//}
//
//class MyStatefulWidget extends StatefulWidget {
//  MyStatefulWidget({Key key}) : super(key: key);
//
//  @override
//  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
//}
//
//class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//  int _count = 0;
//
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: const Text('Sample Code'),
//      ),
//      body: Center(child: Text('You have pressed the button $_count times.')),
//      backgroundColor: Colors.blueGrey.shade200,
//      floatingActionButton: FloatingActionButton(
//        onPressed: () => setState(() => _count++),
//        tooltip: 'Increment Counter',
//        child: const Icon(Icons.add),
//      ),
//    );
//  }
//}