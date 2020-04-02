import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:we_clean/drawer.dart';

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

  static final LatLng center = const LatLng(-33.86711, 151.1947171);
  var marker;

  List<String> cleansListTitle = [];
  List<String> cleansListDesc = [];
  List<double> cleansListLat = [];
  List<double> cleansListLon = [];

  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

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

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/flutter_logo.jpg');
  }

  @override
  Widget build(BuildContext context){
    LatLng pinPosition = LatLng(37.3797536, -122.1017334);
    LatLng pinCurclean = LatLng(StartLat, StartLon);
//    LatLng userLatLng = LatLng(userLocation.latitude, userLocation.longitude);

    // these are the minimum required values to set
    // the camera position
    CameraPosition initialLocation = CameraPosition(
        zoom: 16,
        bearing: 30,
        target: center
    );

    return new Scaffold(
      appBar: AppBar(
        title: const Text('Your Cleans'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height-180,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
//                onMapCreated: _onMapCreated,

              myLocationEnabled: true,
              compassEnabled: true,
                  markers: _markers,
                  initialCameraPosition: initialLocation,
                  onMapCreated: (GoogleMapController controller) {
//                controller.setMapStyle(Utils.mapStyles);
                _controller.complete(controller);



              }),
          ),
        FloatingActionButton(
          onPressed: () {
            getData();
            for(var i = 10; i < 20; i++){
              setState(() {
                _markers.add(
                    Marker(
                        infoWindow: InfoWindow(
                          title: cleansListTitle[i],
                          snippet: cleansListDesc[i],
                        ),
//                        markerId: MarkerId('<MARKER_ID>'),
                        markerId: MarkerId(cleansListTitle[i]),

                        position: LatLng(cleansListLat[i], cleansListLon[i]),
                        icon: pinLocationIcon
                    )
                );
              });

            print(cleansListTitle[i]);
            print(cleansListDesc[i]);
            print(cleansListLat[i]);
            print(cleansListLon[i]);
            print("");
            }
            print("cleansList.length"); // result 0 and it will be executed first
            print(cleansListTitle.length); // result 0 and it will be executed first
          },
          child: Icon(Icons.navigation),
          backgroundColor: Colors.green,
        ),
        ],
      ),
      drawer: MyDrawer(),
    );
  }

  Future getData() async {
    return await databaseReference
        .collection(email)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        cleansListTitle.add(f.data['title']);
        cleansListDesc.add(f.data['description']);
        cleansListLat.add(f.data['StartLat']);
        cleansListLon.add(f.data['StartLon']);

//        print('${f.data}');
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

  Future getDriversList() async {
    return await Firestore.instance.collection(email).getDocuments();
  }

}


class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}