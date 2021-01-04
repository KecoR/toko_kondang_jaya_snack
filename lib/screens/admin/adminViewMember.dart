import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:toko_kondang_jaya_snack/screens/admin/adminAddMember.dart';

class AdminViewMember extends StatefulWidget {
  @override
  _AdminViewMemberState createState() => _AdminViewMemberState();
}

class _AdminViewMemberState extends State<AdminViewMember> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Member'),
        elevation: 5.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (context) => AdminAddMember(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  String _getTextRole(String role) {
    if (role == 'admin') {
      return 'Administrator';
    } else if (role == 'kasir') {
      return 'Kasir';
    } else if (role == 'karyawan') {
      return 'Karyawan';
    } else {
      return 'Member';
    }
  }

  double _getOpacity(String role) {
    if (role == 'admin') {
      return 0;
    } else {
      return 1;
    }
  }

  Widget _buildContent(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                      title: Text(snapshot.data.documents[index]['name']),
                      leading: Container(
                        width: 65.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _getTextRole(
                                  snapshot.data.documents[index]['role']),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(snapshot.data.documents[index]['email']),
                      trailing: Opacity(
                        opacity:
                            _getOpacity(snapshot.data.documents[index]['role']),
                        child: IconButton(
                          icon: Icon(Icons.restore_from_trash),
                          onPressed: () async {
                            if (snapshot.data.documents[index]['role'] ==
                                'admin') {
                              print('delete admin');
                            } else {
                              await FirebaseFirestore.instance
                                  .doc(
                                      'users/${snapshot.data.documents[index].id}')
                                  .delete();
                            }
                          },
                        ),
                      ),
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
