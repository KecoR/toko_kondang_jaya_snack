import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:toko_kondang_jaya_snack/widgets/customRaisedButton.dart';

class AdminNotificationDetail extends StatefulWidget {
  final String id;
  final String warehouseId;
  final String itemName;
  final String warehouseName;

  const AdminNotificationDetail({
    Key key,
    this.id,
    this.warehouseId,
    this.itemName,
    this.warehouseName,
  }) : super(key: key);
  @override
  _AdminNotificationDetailState createState() =>
      _AdminNotificationDetailState();
}

class _AdminNotificationDetailState extends State<AdminNotificationDetail> {
  DocumentSnapshot _snapshot;

  int _stock = 1;

  Map<String, dynamic> _updateDataStock = {};
  Map<String, dynamic> _updateDataProcess = {};

  Future<void> _submit(BuildContext context) async {
    await _updateStock();
    await _updateProcess();
    await _sendWhatsapp();

    Navigator.pop(context);
  }

  Future<void> _sendWhatsapp() async {
    String msg = 'Pesan $_stock ${widget.itemName}';

    await FlutterShareMe().shareToWhatsApp(msg: msg);
  }

  Future<void> _updateStock() async {
    String _itemName = (widget.itemName).replaceAll(' ', '').toLowerCase();

    _snapshot = await FirebaseFirestore.instance
        .collection('warehouses')
        .doc(widget.warehouseId)
        .get()
        .then((warehouse) async {
      _updateDataStock[_itemName] = warehouse[_itemName];
      _updateDataStock[_itemName]['stock'] =
          _updateDataStock[_itemName]['stock'] + _stock;

      await FirebaseFirestore.instance
          .doc('warehouses/${widget.warehouseId}')
          .update(_updateDataStock);
    });
  }

  Future<void> _updateProcess() async {
    _updateDataProcess['process'] = '1';

    await FirebaseFirestore.instance
        .doc('notifications/${widget.id}')
        .update(_updateDataProcess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CustomRaisedButton(
              child: Text('${widget.warehouseName} | ${widget.itemName}'),
              borderRadius: 50.0,
              onPressed: () {},
              color: Colors.white,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _createIncrementDicrementButton(
                  Icons.remove,
                  () {
                    setState(() {
                      if (_stock == 1) return;
                      _stock -= 1;
                    });
                  },
                ),
                Text('  '),
                Text(_stock.toString()),
                Text('  '),
                _createIncrementDicrementButton(
                  Icons.add,
                  () {
                    setState(() {
                      _stock += 1;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            CustomRaisedButton(
              child: Text(
                'Process',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              borderRadius: 100,
              onPressed: () => _submit(context),
            ),
          ],
        ),
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
}
