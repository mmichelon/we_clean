import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:we_clean/drawer.dart';

import 'package:we_clean/map_screen.dart';

import 'package:fluster/fluster.dart';
import 'package:we_clean/helpers/map_marker.dart';
import 'package:we_clean/helpers/map_helper.dart';

class MapDirtyScreen extends StatefulWidget {
  final name;
  final email;

  final StartLat;
  final StartLon;

  final title;
  final description;

  MapDirtyScreen(this.name, this.email, this.StartLat, this.StartLon, this.title, this.description);
  @override
  State<MapDirtyScreen> createState() => MyMapDirtyState(name, email, StartLat, StartLon, title, description);
}

class MyMapDirtyState extends State<MapDirtyScreen> {
  final email;
  final name;

  final StartLat;
  final StartLon;

  final title;
  final description;

  Geolocator geolocator = Geolocator();
  Position userLocation;
//  GoogleMapController mapController;

  //Get database information
//  final databaseReference = Firestore.instance;
//  QuerySnapshot querySnapshot;

  MyMapDirtyState(this.name, this.email, this.StartLat, this.StartLon, this.title, this.description);

  static final LatLng center = const LatLng(-33.86711, 151.1947171);

  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LatLng pinCurcleanStart = LatLng(StartLat, StartLon);
    print("pinCurcleanStart");
    print(pinCurcleanStart);
//    LatLng pinCurcleanEnd = LatLng(EndLat, EndLon);

    // these are the minimum required values to set
    // the camera position
    CameraPosition initialLocation = CameraPosition(
        zoom: 16,
        bearing: 30,
        target: pinCurcleanStart
    );

    return new Scaffold(
      appBar: AppBar(
        title: const Text('Dirty Location'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height-80,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
                myLocationEnabled: true,
                compassEnabled: true,
                markers: _markers,
                initialCameraPosition: initialLocation,
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(Utils.mapStyles);
                  _controller.complete(controller);
                  setState(() {
                    _markers.add(
                        Marker(
                            infoWindow: InfoWindow(
                              title: title,
                              snippet: description,
                            ),
                            markerId: MarkerId(title),
                            position: pinCurcleanStart,
                            icon: pinLocationIcon
                        )
                    );
//                    _markers.add(
//                        Marker(
//                            infoWindow: InfoWindow(
//                              title: "End",
//                              snippet: "",
//                            ),
//                            markerId: MarkerId("End"),
//                            position: pinCurcleanEnd,
//                            icon: pinLocationIcon
//                        )
//                    );
                  });
                }),
          ),
        ],
      ),

      drawer: MyDrawer(),
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