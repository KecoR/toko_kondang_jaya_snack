import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toko_kondang_jaya_snack/screens/admin/mapScreen.dart';

class AdminAddWarehouse extends StatefulWidget {
  @override
  _AdminAddWarehouseState createState() => _AdminAddWarehouseState();
}

class _AdminAddWarehouseState extends State<AdminAddWarehouse> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _nameController = TextEditingController();

  Map<String, dynamic> _data = {
    'madani': {'stock': 50, 'price': 0},
    'basreng': {'stock': 50, 'price': 0},
    'latansa': {'stock': 50, 'price': 0},
    'krupukkulit': {'stock': 50, 'price': 0},
    'piarz': {'stock': 50, 'price': 0},
  };

  String _text = 'Select Location';

  void _selectLocation() async {
    final location = await Navigator.pushNamed(context, MapScreen.routeName);
    if (location != null) {
      Map<String, dynamic> _locationSelected = location;
      setState(() {
        _text = _locationSelected['address'];
        _data['latitude'] = _locationSelected['latitude'];
        _data['longitude'] = _locationSelected['longitude'];
        _data['address'] = _locationSelected['address'];
      });
    }
  }

  Future<void> _submit(BuildContext context) async {
    DocumentReference reference =
        // ignore: deprecated_member_use
        await Firestore.instance.collection('warehouses').add(_data);

    print(reference.id);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Warehouse'),
        elevation: 5.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _submit(context),
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _createIncrementDicrementButton(IconData icon, Function onPressed) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      constraints: BoxConstraints(minWidth: 32.0, minHeight: 32.0),
      onPressed: onPressed,
      elevation: 2.0,
      fillColor: Colors.blue,
      child: Icon(
        icon,
        color: Colors.white,
        size: 12.0,
      ),
      shape: CircleBorder(),
    );
  }

  Widget _listItems(
      String text, int dataQty, String dataName, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _createIncrementDicrementButton(
              Icons.remove,
              () {
                setState(() {
                  if (_data[dataName]['stock'] == 50) return;
                  _data[dataName]['stock'] -= 1;
                });
              },
            ),
            Text('  '),
            Text(_data[dataName]['stock'].toString()),
            Text('  '),
            _createIncrementDicrementButton(
              Icons.add,
              () {
                setState(() {
                  _data[dataName]['stock'] += 1;
                });
              },
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 200,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 16.0, right: 16.0),
                          child: TextField(
                            decoration: new InputDecoration(
                                labelText: "Enter your price"),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              if (int.parse(value) != null &&
                                  int.parse(value) > 0) {
                              } else {
                                value = '0';
                              }
                              setState(() {
                                _data[dataName]['price'] = int.parse(value);
                              });
                            },
                          ),
                        ),
                        ElevatedButton(
                          child: const Text('Save'),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Text('${_data[dataName]['price']}'),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 5.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Warehouse Name',
                hintText: 'Warehouse Name...',
              ),
              autocorrect: false,
              onChanged: (value) {
                setState(() {
                  _data['name'] = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              child: ListTile(
                title: Row(
                  children: [
                    Flexible(
                      child: Text(
                        _text,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                trailing: Icon(Icons.map),
              ),
              onTap: _selectLocation,
            ),
            SizedBox(height: 16.0),
            _listItems('Madani', _data['madani']['stock'], 'madani', context),
            SizedBox(height: 16.0),
            _listItems(
                'Basreng', _data['basreng']['stock'], 'basreng', context),
            SizedBox(height: 16.0),
            _listItems(
                'Latansa', _data['latansa']['stock'], 'latansa', context),
            SizedBox(height: 16.0),
            _listItems('Krupuk Kulit', _data['krupukkulit']['stock'],
                'krupukkulit', context),
            SizedBox(height: 16.0),
            _listItems('Pia RZ', _data['piarz']['stock'], 'piarz', context),
          ],
        ),
      ),
    );
  }
}
