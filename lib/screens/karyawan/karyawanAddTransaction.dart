import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toko_kondang_jaya_snack/models/appConstants.dart';

class KaryawanAddTransaction extends StatefulWidget {
  final String uid;

  const KaryawanAddTransaction({Key key, this.uid}) : super(key: key);

  @override
  _KaryawanAddTransactionState createState() => _KaryawanAddTransactionState();
}

class _KaryawanAddTransactionState extends State<KaryawanAddTransaction> {
  bool _loadData = true;

  List<String> _users = [];
  Map<String, dynamic> _data = {
    'madani': 0,
    'basreng': 0,
    'latansa': 0,
    'krupukkulit': 0,
    'piarz': 0,
    'warehouseId': '',
    'process': '0',
  };

  String _selectedUser;

  Future<void> _submit(BuildContext context) async {
    await FirebaseFirestore.instance.collection('transactions').add(_data);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _submit(context),
        child: Icon(Icons.save),
      ),
      body: _buildContent(context),
    );
  }

  @override
  void initState() {
    _data['karyawan'] = AppConstants.currentUser.name;
    _data['warehouseId'] = widget.uid;
    _fetchUserData();
    super.initState();
  }

  Future<void> _fetchUserData() async {
    await FirebaseFirestore.instance.collection('users').get().then((data) {
      if (data.docs.isNotEmpty) {
        for (int i = 0; i < data.docs.length; i++) {
          if (data.docs[i]['role'] == 'Member') {
            _users.add(data.docs[i]['name']);
          }
        }
        _loadData = false;
        setState(() {});
      }
    });
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

  Widget _listItems(String text, String dataName, BuildContext context) {
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
                  if (_data[dataName] == 0) return;
                  _data[dataName] -= 1;
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
                  _data[dataName] += 1;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(context) {
    if (_loadData) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    setState(() {
      _data['member'] = _users[0];
    });

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 5.0),
            DropdownButton(
              isExpanded: true,
              value: _selectedUser,
              hint: Text('Select Member'),
              items: _users.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _data['member'] = value;
                  _selectedUser = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            _listItems('Madani', 'madani', context),
            SizedBox(height: 16.0),
            _listItems('Basreng', 'basreng', context),
            SizedBox(height: 16.0),
            _listItems('Latansa', 'latansa', context),
            SizedBox(height: 16.0),
            _listItems('Krupuk Kulit', 'krupukkulit', context),
            SizedBox(height: 16.0),
            _listItems('Pia RZ', 'piarz', context),
          ],
        ),
      ),
    );
  }
}
