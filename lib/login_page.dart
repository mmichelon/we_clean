import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'package:we_clean/sign_in.dart';
import 'package:we_clean/cleans_screen.dart';
import 'package:we_clean/about.dart';


import 'package:fluttertoast/fluttertoast.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/we_clean.png',),
              SizedBox(height: 50),
              _signInGoogleButton(),
//              SizedBox(height: 20),
//              _signInAnonButton(),
            ],
          ),
        ),
      ),
    );
  }

  void showLongToast(String name) {
    Fluttertoast.showToast(
      msg: "Welcome " + name,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  Widget _signInGoogleButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          showLongToast(name);
          Navigator.push(
            context,
            MaterialPageRoute(
//                builder: (context) => CleansScreen(name, email)),
                builder: (context) => AboutScreen(name, email)),

          );
//          Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (context) {
//                return HomeScreen();
//              },
//            ),
//          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.jpg"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _signInAnonButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        _signInAnonymously;
//        signInWithGoogle().whenComplete(() {
//          Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (context) {
//                return FirstScreen();
//              },
//            ),
//          );
//        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/anonymous-user.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in Anonomously',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }
}