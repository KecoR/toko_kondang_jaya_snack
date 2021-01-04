import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdminMonitoring extends StatefulWidget {
  @override
  _AdminMonitoringState createState() => _AdminMonitoringState();
}

class _AdminMonitoringState extends State<AdminMonitoring> {
  static LatLng _center;
  Map<String, dynamic> _location = {};
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  DocumentSnapshot _snapshot;
  Map<String, dynamic> _data = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoring View'),
        elevation: 5.0,
      ),
      body: Stack(
        children: <Widget>[
          _googleMap(context),
        ],
      ),
    );
  }

  Future<void> _fetchData(String id) async {
    _snapshot =
        // ignore: deprecated_member_use
        await Firestore.instance.collection('warehouses').doc(id).get();
    _data['madani'] = _snapshot['madani']['stock'];
    _data['basreng'] = _snapshot['basreng']['stock'];
    _data['latansa'] = _snapshot['latansa']['stock'];
    _data['krupukkulit'] = _snapshot['krupukkulit']['stock'];
    _data['piarz'] = _snapshot['piarz']['stock'];
    setState(() {});
  }

  _setLatLong() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((position) {
      _location['latitude'] = position.latitude;
      _location['longitude'] = position.longitude;
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _setLatLong();
    getMarkerData();
    super.initState();
  }

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(specify['latitude'], specify['longitude']),
        infoWindow:
            InfoWindow(title: specify['name'], snippet: specify['address']),
        onTap: () async {
          await _fetchData(specify.id);
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 180,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text('Item Name'),
                          SizedBox(height: 8),
                          Text('Madani'),
                          SizedBox(height: 8),
                          Text('Basreng'),
                          SizedBox(height: 8),
                          Text('Latansa'),
                          SizedBox(height: 8),
                          Text('Krupuk Kulit'),
                          SizedBox(height: 8),
                          Text('Pia RZ'),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text('Stock'),
                          SizedBox(height: 8),
                          Text('${_data['madani']}'),
                          SizedBox(height: 8),
                          Text('${_data['basreng']}'),
                          SizedBox(height: 8),
                          Text('${_data['latansa']}'),
                          SizedBox(height: 8),
                          Text('${_data['krupukkulit']}'),
                          SizedBox(height: 8),
                          Text('${_data['piarz']}'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          ;
        });
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance.collection('warehouses').get().then((data) {
      if (data.docs.isNotEmpty) {
        for (int i = 0; i < data.docs.length; i++) {
          initMarker(data.docs[i], data.docs[i].id);
        }
      }
    });
  }

  Widget _googleMap(BuildContext context) {
    if (_center == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 17.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }
}
