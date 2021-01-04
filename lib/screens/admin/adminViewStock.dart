import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toko_kondang_jaya_snack/screens/admin/adminAddWarehouse.dart';
import 'package:toko_kondang_jaya_snack/screens/admin/detailStockWarehouse.dart';

class AdminViewStock extends StatefulWidget {
  @override
  _AdminViewStockState createState() => _AdminViewStockState();
}

class _AdminViewStockState extends State<AdminViewStock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Stock'),
        elevation: 5.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (context) => AdminAddWarehouse(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('warehouses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.all(2.0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 8.0,
                margin:
                    new EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                child: Container(
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    leading: Container(
                      padding: EdgeInsets.only(right: 5.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(
                                  width: 1.0, color: Colors.white24))),
                      child: IconButton(
                        icon: Icon(Icons.restore_from_trash),
                        color: Colors.white,
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .doc(
                                  'warehouses/${snapshot.data.documents[index].id}')
                              .delete();
                        },
                      ),
                    ),
                    title: Text(
                      snapshot.data.documents[index]['name'],
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.linear_scale, color: Colors.yellowAccent),
                        Flexible(
                          child: Text(
                            snapshot.data.documents[index]['address'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right,
                        color: Colors.white, size: 30.0),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          fullscreenDialog: true,
                          builder: (context) => DetailStockWarehouse(
                            id: snapshot.data.documents[index].id,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
