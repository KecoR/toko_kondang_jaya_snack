import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailStockWarehouse extends StatefulWidget {
  final String id;

  const DetailStockWarehouse({Key key, @required this.id}) : super(key: key);

  @override
  _DetailStockWarehouseState createState() => _DetailStockWarehouseState();
}

class _DetailStockWarehouseState extends State<DetailStockWarehouse> {
  DocumentSnapshot _snapshot;

  Map<String, dynamic> _data = {};

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    _snapshot =
        // ignore: deprecated_member_use
        await Firestore.instance.collection('warehouses').doc(widget.id).get();
    _data['madani'] = _snapshot['madani'];
    _data['basreng'] = _snapshot['basreng'];
    _data['latansa'] = _snapshot['latansa'];
    _data['krupukkulit'] = _snapshot['krupukkulit'];
    _data['piarz'] = _snapshot['piarz'];
    setState(() {});
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

  Future<void> _submit(BuildContext context) async {
    await FirebaseFirestore.instance
        .doc('warehouses/${_snapshot.id}')
        .update(_data);

    Navigator.pop(context);
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 5.0),
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

  @override
  Widget build(BuildContext context) {
    if (_snapshot != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_snapshot['name']),
          elevation: 5.0,
        ),
        body: _buildContent(),
        backgroundColor: Colors.grey[200],
        floatingActionButton: FloatingActionButton(
          onPressed: () => _submit(context),
          child: Icon(Icons.save),
        ),
      );
    } else {
      if (_snapshot == null) {
        return Center(child: CircularProgressIndicator());
      }
    }
  }
}
