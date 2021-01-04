import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();

  static const routeName = '/map';
}

class _MapScreenState extends State<MapScreen> {
  static double latitude = 0;
  static double longitude = 0;

  Map<String, dynamic> _location = {
    'latitude': 0,
    'longitude': 0,
    'address': '',
  };

  Completer<GoogleMapController> _controller = Completer();
  static LatLng _center;
  LatLng _lastMapPosition = _center;

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _getAddressFromLatLng() async {
    try {
      var coordinates =
          new Coordinates(_location['latitude'], _location['longitude']);
      var address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      _location['address'] = address.first.addressLine;
    } catch (e) {
      print(e);
    }
  }

  _setLatLong() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((position) {
      print('location : ${position}');
      _location['latitude'] = position.latitude;
      _location['longitude'] = position.longitude;
      _getAddressFromLatLng();
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _setLatLong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_center == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Lokasi'),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 18.0,
            ),
            mapType: MapType.normal,
            onCameraMove: _onCameraMove,
            markers: <Marker>{
              Marker(
                markerId: MarkerId('Location'),
                position: _center,
                icon: BitmapDescriptor.defaultMarker,
                draggable: true,
                onDragEnd: (LatLng latLng) {
                  setState(() {
                    _center = LatLng(latLng.latitude, latLng.longitude);
                    _location['latitude'] = latLng.latitude;
                    _location['longitude'] = latLng.longitude;
                    _getAddressFromLatLng();
                  });
                },
              ),
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _location);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
