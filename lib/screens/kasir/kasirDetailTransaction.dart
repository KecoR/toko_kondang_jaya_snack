import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toko_kondang_jaya_snack/widgets/customRaisedButton.dart';

class KasirDetailTransaction extends StatefulWidget {
  final String uid;

  const KasirDetailTransaction({Key key, this.uid}) : super(key: key);
  @override
  _KasirDetailTransactionState createState() => _KasirDetailTransactionState();
}

class _KasirDetailTransactionState extends State<KasirDetailTransaction> {
  DocumentSnapshot _snapshot;

  Map<String, dynamic> _data = {};
  Map<String, dynamic> _amount = {};
  Map<String, dynamic> _dataWarehouse = {};
  Map<String, dynamic> _updateData = {};
  Map<String, dynamic> _updateStock = {};
  Map<String, dynamic> _notificationData = {};

  List<String> _itemLists = [
    'madani',
    'basreng',
    'latansa',
    'krupuk kulit',
    'piarz',
  ];

  Map<String, String> _objectItemLists = {
    'madani': 'Madani',
    'basreng': 'Basreng',
    'latansa': 'Latansa',
    'krupukkulit': 'Krupukkulit',
    'piarz': 'Pia RZ',
  };

  double _opacity = 0;

  Future<void> _fetchData() async {
    _snapshot =
        // ignore: deprecated_member_use
        await Firestore.instance
            .collection('transactions')
            .doc(widget.uid)
            .get();
    _data['madani'] = _snapshot['madani'];
    _data['basreng'] = _snapshot['basreng'];
    _data['latansa'] = _snapshot['latansa'];
    _data['krupukkulit'] = _snapshot['krupukkulit'];
    _data['piarz'] = _snapshot['piarz'];
    _data['member'] = _snapshot['member'];
    _data['warehouseId'] = _snapshot['warehouseId'];

    await FirebaseFirestore.instance
        .collection('warehouses')
        .doc(_snapshot['warehouseId'])
        .get()
        .then((value) {
      _dataWarehouse['madani'] = value['madani'];
      _dataWarehouse['basreng'] = value['basreng'];
      _dataWarehouse['latansa'] = value['latansa'];
      _dataWarehouse['krupukkulit'] = value['krupukkulit'];
      _dataWarehouse['piarz'] = value['piarz'];
      _dataWarehouse['name'] = value['name'];

      _calculatePrice();
    });
    setState(() {});
  }

  void _calculatePrice() {
    _amount['madani'] = _data['madani'] * _dataWarehouse['madani']['price'];
    _amount['basreng'] = _data['basreng'] * _dataWarehouse['basreng']['price'];
    _amount['latansa'] = _data['latansa'] * _dataWarehouse['latansa']['price'];
    _amount['krupukkulit'] =
        _data['krupukkulit'] * _dataWarehouse['krupukkulit']['price'];
    _amount['piarz'] = _data['piarz'] * _dataWarehouse['piarz']['price'];
    _amount['total'] = _amount['madani'] +
        _amount['basreng'] +
        _amount['latansa'] +
        _amount['krupukkulit'] +
        _amount['piarz'];
  }

  Future<void> _submit(BuildContext context) async {
    _updateProcess();
    _updateStockProcess();
    Navigator.pop(context);
  }

  void _updateProcess() async {
    _updateData['process'] = "1";

    await FirebaseFirestore.instance
        .doc('transactions/${widget.uid}')
        .update(_updateData);
  }

  void _updateStockProcess() async {
    for (int i = 0; i < _itemLists.length; i++) {
      int _stock =
          _dataWarehouse[_itemLists[i]]['stock'] - _data[_itemLists[i]];
      _updateStock[_itemLists[i]] = {
        'stock': _stock,
        'price': _dataWarehouse[_itemLists[i]]['price'],
      };
      if (_stock < 50) {
        _addNotification(_objectItemLists[_itemLists[i]]);
      }

      await FirebaseFirestore.instance
          .doc('warehouses/${_data['warehouseId']}')
          .update(_updateStock);
    }
  }

  Future<void> _addNotification(String item) async {
    _notificationData['message'] = 'Stock item $item kurang dari 50';
    _notificationData['warehouseId'] = _data['warehouseId'];
    _notificationData['warehouseName'] = _dataWarehouse['name'];
    _notificationData['process'] = '0';

    await FirebaseFirestore.instance
        .collection('notifications')
        .add(_notificationData);
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Detail'),
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContent(context),
    );
  }

  Widget _createIncrementDicrementButton(IconData icon, Function onPressed) {
    return Opacity(
      opacity: _opacity,
      child: RawMaterialButton(
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
      ),
    );
  }

  Widget _totalPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Opacity(
          opacity: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _createIncrementDicrementButton(
                Icons.remove,
                () {
                  setState(() {
                    if (_data['madani'] == 0) return;
                    _data['madani'] -= 1;
                    _calculatePrice();
                  });
                },
              ),
              Text('  '),
              Text(_data['madani'].toString()),
              Text('  '),
              _createIncrementDicrementButton(
                Icons.add,
                () {
                  setState(() {
                    if (_data['madani'] == _dataWarehouse['madani']['stock'])
                      return;
                    _data['madani'] += 1;
                    _calculatePrice();
                  });
                },
              ),
            ],
          ),
        ),
        Text(
          'Total',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Text(
          NumberFormat.currency(locale: 'id', symbol: 'Rp.', decimalDigits: 0)
              .format(_amount['total']),
        ),
      ],
    );
  }

  Widget _listItems(String text, String dataName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _createIncrementDicrementButton(
              Icons.remove,
              () {
                setState(() {
                  if (_data[dataName] == 0) return;
                  _data[dataName] -= 1;
                  _calculatePrice();
                });
              },
            ),
            Text('  '),
            Text(_data[dataName].toString()),
            Text('  '),
            _createIncrementDicrementButton(
              Icons.add,
              () {
                setState(() {
                  if (_data[dataName] == _dataWarehouse[dataName]['stock'])
                    return;
                  _data[dataName] += 1;
                  _calculatePrice();
                });
              },
            ),
          ],
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Text(
          NumberFormat.currency(locale: 'id', symbol: 'Rp.', decimalDigits: 0)
              .format(_amount[dataName]),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_snapshot == null) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 5.0),
            CustomRaisedButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(_data['member']),
                ],
              ),
              color: Colors.white,
              borderRadius: 50.0,
              height: 70.0,
              onPressed: () {},
            ),
            SizedBox(height: 16.0),
            _listItems('Madani', 'madani'),
            SizedBox(height: 16.0),
            _listItems('Basreng', 'basreng'),
            SizedBox(height: 16.0),
            _listItems('Latansa', 'latansa'),
            SizedBox(height: 16.0),
            _listItems('Krupuk Kulit', 'krupukkulit'),
            SizedBox(height: 16.0),
            _listItems('Pia RZ', 'piarz'),
            SizedBox(height: 16.0),
            _totalPrice(),
            SizedBox(height: 32.0),
            CustomRaisedButton(
              child: Text('Edit'),
              color: Colors.blueGrey,
              borderRadius: 50.0,
              onPressed: () {
                setState(() {
                  _opacity = 1;
                });
              },
            ),
            SizedBox(height: 16.0),
            CustomRaisedButton(
              child: Text('Save & Process'),
              color: Colors.green,
              borderRadius: 50.0,
              onPressed: () => _submit(context),
            ),
          ],
        ),
      ),
    );
  }
}
