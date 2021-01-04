import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toko_kondang_jaya_snack/screens/admin/adminNotificationDetail.dart';

class AdminNotification extends StatefulWidget {
  @override
  _AdminNotificationState createState() => _AdminNotificationState();
}

class _AdminNotificationState extends State<AdminNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .where("process", isEqualTo: "0")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.all(2.0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 8.0,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title:
                          Text(snapshot.data.documents[index]['warehouseName']),
                      subtitle: Row(
                        children: <Widget>[
                          Icon(Icons.linear_scale, color: Colors.greenAccent),
                          Flexible(
                            child: Text(
                              snapshot.data.documents[index]['message'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            fullscreenDialog: true,
                            builder: (context) => AdminNotificationDetail(
                              id: snapshot.data.documents[index].id,
                              warehouseId: snapshot.data.documents[index]
                                  ['warehouseId'],
                              itemName: snapshot.data.documents[index]
                                  ['itemName'],
                              warehouseName: snapshot.data.documents[index]
                                  ['warehouseName'],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
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
