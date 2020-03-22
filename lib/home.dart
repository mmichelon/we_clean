//import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:geolocator/geolocator.dart';
//import 'dart:async';
//import 'package:cloud_firestore/cloud_firestore.dart';
//
//import 'package:we_clean/drawer.dart';
//
//class HomeScreen extends StatefulWidget {
//  final name;
//  final email;
//
//  HomeScreen(this.name, this.email);
//  @override
//  State<HomeScreen> createState() => MyMapState(name, email);
//}
//
//class MyMapState extends State<HomeScreen> {
//  final email;
//  final name;
//
//  Geolocator geolocator = Geolocator();
//  Position userLocation;
//  GoogleMapController mapController;
//
//  final databaseReference = Firestore.instance;
//
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _getLocation().then((position) {
//      userLocation = position;
//      print("In maps screen");
//      print(userLocation);
//    });
//  }
//
//  MyMapState(this.name, this.email);
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: AppBar(
//        title: const Text('We Clean Profile'),
//      ),
//      body: Column(
//          children: <Widget>[
//      Container(
//        height: MediaQuery.of(context).size.height-80,
//        width: MediaQuery.of(context).size.width,
//        child: GoogleMap(
//          onMapCreated: (GoogleMapController controller) {
//            mapController = controller;
//          },
//            initialCameraPosition: CameraPosition(
//              target: LatLng(37.4219999, -122.0862462),
//              zoom: 11,
//
//            ),
//        ),
//        ),
//        ],
//      ),
//    floatingActionButton: FloatingActionButton(onPressed: () {
//      mapController.animateCamera(
//        CameraUpdate.newCameraPosition(
//        CameraPosition(
//          target: LatLng(userLocation.latitude, userLocation.longitude), zoom: 10.0),
//        ),
//      );
//    },
//        child: Icon(Icons.my_location),
//    ),
//    drawer: MyDrawer(),
//    );
//  }
//  Future<Position> _getLocation() async {
//    var currentLocation;
//    try {
//      currentLocation = await geolocator.getCurrentPosition(
//          desiredAccuracy: LocationAccuracy.best);
//    } catch (e) {
//      currentLocation = null;
//    }
//    return currentLocation;
//  }
//}