import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:location/location.dart';
import 'dart:async';

import 'package:we_clean/login_page.dart';
import 'package:we_clean/sign_in.dart';
import 'package:we_clean/cleans_screen.dart';


class HomeScreen extends StatefulWidget {
  final name;
  final email;
  var lat;
  var lon;

  HomeScreen(this.name, this.email);
  @override
  State<HomeScreen> createState() => MyMapState(name, email, lat, lon);
}

class MyMapState extends State<HomeScreen> {
  final email;
  final name;
  var lat;
  var lon;
//  final Map<String, Marker> _markers = {};
  Geolocator geolocator = Geolocator();
  Position userLocation;
  GoogleMapController mapController;
//  Location location = Location();

  Marker marker;

  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
      lat = userLocation.latitude;
      lon = userLocation.longitude;

      print(userLocation);
    });
  }

  MyMapState(this.name, this.email, this.lat, this.lon);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('We Clean Profile'),
      ),
      body: Column(
          children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height-80,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
            initialCameraPosition: CameraPosition(
              target: LatLng(37.4219999, -122.0862462),
              zoom: 11,

            ),
        ),
        ),
        ],
      ),
    floatingActionButton: FloatingActionButton(onPressed: () {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(userLocation.latitude, userLocation.longitude), zoom: 10.0),
        ),
      );
    },
        child: Icon(Icons.my_location),
    ),
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
  }
  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}


//class HomeScreen extends StatelessWidget {
//  GoogleMapController mapController;
//  final LatLng _center = const LatLng(45.521563, -122.677433);
//  void _onMapCreated(GoogleMapController controller) {
//    mapController = controller;
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: const Text('We Clean Profile'),
//      ),
//      drawer: Drawer(
//        child: ListView(
//          padding: EdgeInsets.zero,
//          children: <Widget>[
//            DrawerHeader(
//              decoration: BoxDecoration(
//                color: Colors.blue,
//              ),
//              child: Text(
//                name + '\'s profile',
//                style: TextStyle(
//                  color: Colors.white,
//                  fontSize: 24,
//                ),
//              ),
//            ),
//            ListTile(
//              leading: Icon(Icons.message),
//              title: Text('Messages'),
//              trailing: Icon(Icons.keyboard_arrow_right),
//              onTap: (){
//                print('camel');
//              },
//            ),
//            ListTile(
//              leading: Icon(Icons.account_circle),
//              title: Text(email),
//            ),
//            ListTile(
//              leading: Icon(Icons.settings),
//              title: Text('Settings'),
//            ),
//          ],
//        ),
//      ),
//
//        body: GoogleMap(
//          onMapCreated: _onMapCreated,
//          initialCameraPosition: CameraPosition(
//            target: _center,
//            zoom: 11.0,
//          ),
//        ),
//    );
//  }
//}