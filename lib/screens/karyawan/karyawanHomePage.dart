import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toko_kondang_jaya_snack/screens/loginPage.dart';
import 'package:toko_kondang_jaya_snack/screens/karyawan/karyawanAddTransaction.dart';

class KaryawanHomePage extends StatefulWidget {
  static final String routeName = '/karyawanPageRoute';

  @override
  _KaryawanHomePageState createState() => _KaryawanHomePageState();
}

class _KaryawanHomePageState extends State<KaryawanHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Karyawan'),
        elevation: 5.0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, LoginPage.routeName),
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContent(context),
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
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(snapshot.data.documents[index]['name']),
                      subtitle: Row(
                        children: <Widget>[
                          Icon(Icons.linear_scale, color: Colors.greenAccent),
                          Flexible(
                            child: Text(
                              snapshot.data.documents[index]['address'],
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
                            builder: (context) => KaryawanAddTransaction(
                                uid: snapshot.data.documents[index].id),
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
