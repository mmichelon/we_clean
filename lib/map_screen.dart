import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:we_clean/drawer.dart';

import 'package:fluster/fluster.dart';
import 'package:we_clean/helpers/map_marker.dart';
import 'package:we_clean/helpers/map_helper.dart';

class MapScreen extends StatefulWidget {
  final name;
  final email;

  final StartLat;
  final StartLon;

  MapScreen(this.name, this.email, this.StartLat, this.StartLon);
  @override
  State<MapScreen> createState() => MyMapState(name, email, StartLat, StartLon);
}

class MyMapState extends State<MapScreen> {
  final email;
  final name;

  final StartLat;
  final StartLon;

  Geolocator geolocator = Geolocator();
  Position userLocation;
//  GoogleMapController mapController;

  final databaseReference = Firestore.instance;
  QuerySnapshot querySnapshot;

  MyMapState(this.name, this.email, this.StartLat, this.StartLon);

  static final LatLng center = const LatLng(39.729656, -121.846247);
  var marker;

  List<String> cleansListTitle = [];
  List<String> cleansListDesc = [];
  List<double> cleansListLat = [];
  List<double> cleansListLon = [];

//  BitmapDescriptor pinLocationIcon;
//  Set<Marker> _markers = {};
//  Completer<GoogleMapController> _controller = Completer();

/////////////////////////////////////////////////////////////////
  @override
  void initState(){

    _getLocation().then((position) {
      userLocation = position;

      print("In general map");
      print(userLocation);
    });
    super.initState();
    getData();
  }

  final Completer<GoogleMapController> _mapController = Completer();

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();
  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;
  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;
  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;
  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;
  /// Map loading flag
  bool _isMapLoading = true;
  /// Markers loading flag
  bool _areMarkersLoading = true;
  /// Url image used on normal markers
  final String _markerImageUrlStart = 'https://img.icons8.com/office/80/000000/marker.png';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;
  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;
  final List<LatLng> _cleanLocations = [];

  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
    setState(() {
      _isMapLoading = false;
    });
    _initMarkers();
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    final List<MapMarker> markers = [];
    for(var i = 0; i < cleansListLat.length; i++){
      _cleanLocations.add(LatLng(cleansListLat[i], cleansListLon[i]));
    }
//    var i = 0;
    for (LatLng markerLocation in _cleanLocations) {
//      i++;
      print("markerLocation: ");
      print(markerLocation);
      final BitmapDescriptor markerImage =
      await MapHelper.getMarkerImageFromUrl(_markerImageUrlStart);
      markers.add(
        MapMarker(
          id: _cleanLocations.indexOf(markerLocation).toString(),
          Title: cleansListTitle[_cleanLocations.indexOf(markerLocation)],
          Description: cleansListDesc[_cleanLocations.indexOf(markerLocation)],
          position: markerLocation,
          icon: markerImage,
        ),
      );
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
          title: Text('All your cleans'),
        ),
        body: Stack(
          children: <Widget>[
        // Google Map widget
        Opacity(
        opacity: _isMapLoading ? 0 : 1,
          child: GoogleMap(
            myLocationEnabled: true,
            mapToolbarEnabled: false,
            initialCameraPosition: CameraPosition(
              target: center,
              zoom: _currentZoom,
            ),
            markers: _markers,
            onMapCreated: (controller) => _onMapCreated(controller),
            onCameraMove: (position) => _updateMarkers(position.zoom),
          ),
        ),

        // Map loading indicator
        Opacity(
          opacity: _isMapLoading ? 1 : 0,
          child: Center(child: CircularProgressIndicator()),
        ),

        // Map markers loading indicator
        if (_areMarkersLoading)
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Card(
          elevation: 2,
          color: Colors.grey.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              'Loading',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    ),
    ],
    ),
    drawer: MyDrawer(),

    );
  }
//  @override
//  void initState(){
//
//    _getLocation().then((position) {
//      userLocation = position;
//
//      print("In general map");
//      print(userLocation);
//    });
//    super.initState();
//    getData();
//  }
//
//  @override
//  Widget build(BuildContext context){
//
//    // these are the minimum required values to set
//    // the camera position
//    CameraPosition initialLocation = CameraPosition(
//        zoom: 16,
//        bearing: 30,
//        target: center
//    );
//
//    return new Scaffold(
//      appBar: AppBar(
//        title: const Text('Your Cleans'),
//      ),
//      body: Column(
//        children: <Widget>[
//          Container(
//            height: MediaQuery.of(context).size.height-180,
//            width: MediaQuery.of(context).size.width,
//            child: GoogleMap(
////                onMapCreated: _onMapCreated,
//
//              myLocationEnabled: true,
//              compassEnabled: true,
//                  markers: _markers,
//                  initialCameraPosition: initialLocation,
//                  onMapCreated: (GoogleMapController controller) {
//                _controller.complete(controller);
//              }),
//          ),
//        FloatingActionButton(
//          onPressed: () {
////            getData();
//            for(var i = 0; i < cleansListTitle.length; i++){
//              setState(() {
//                _markers.add(
//                    Marker(
//                        infoWindow: InfoWindow(
//                          title: cleansListTitle[i],
//                          snippet: cleansListDesc[i],
//                        ),
//                        markerId: MarkerId(cleansListTitle[i]),
//
//                        position: LatLng(cleansListLat[i], cleansListLon[i]),
//                        icon: pinLocationIcon
//                    )
//                );
//              });
////            print(cleansListTitle[i]);
//            print("");
//            }
//            print("cleansList.length"); // result 0 and it will be executed first
//            print(cleansListTitle.length); // result 0 and it will be executed first
//          },
//          child: Icon(Icons.navigation),
//          backgroundColor: Colors.green,
//        ),
//        ],
//      ),
//      drawer: MyDrawer(),
//    );
//  }

  Future getData() async {
    return await databaseReference
        .collection(email)
        .document('Cleans').collection('Cleans')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        cleansListTitle.add(f.data['title']);
        cleansListDesc.add(f.data['description']);
        cleansListLat.add(f.data['StartLat']);
        cleansListLon.add(f.data['StartLon']);
        print('${f.data}');
      }
      );
    });
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