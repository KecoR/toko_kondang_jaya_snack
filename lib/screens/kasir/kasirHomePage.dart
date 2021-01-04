import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toko_kondang_jaya_snack/screens/loginPage.dart';
import 'package:toko_kondang_jaya_snack/screens/kasir/kasirDetailTransaction.dart';
import 'package:toko_kondang_jaya_snack/widgets/customRaisedButton.dart';

class KasirHomePage extends StatelessWidget {
  static final String routeName = '/kasirPageRoute';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Kasir'),
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
      stream: FirebaseFirestore.instance
          .collection('transactions')
          .where('process', isEqualTo: "0")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.all(2.0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Color(0x00000000),
                elevation: 0,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  children: <Widget>[
                    CustomRaisedButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    snapshot.data.documents[index]['karyawan']),
                                Text('|'),
                                Text(snapshot.data.documents[index]['member']),
                              ],
                            ),
                          )
                        ],
                      ),
                      color: Colors.white,
                      borderRadius: 50.0,
                      height: 70.0,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            fullscreenDialog: true,
                            builder: (context) => KasirDetailTransaction(
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
