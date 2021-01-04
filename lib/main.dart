import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:toko_kondang_jaya_snack/models/appConstants.dart';
import 'package:toko_kondang_jaya_snack/screens/admin/adminHomePage.dart';
import 'package:toko_kondang_jaya_snack/screens/admin/mapScreen.dart';
import 'package:toko_kondang_jaya_snack/screens/guest/guestHomePage.dart';
import 'package:toko_kondang_jaya_snack/screens/karyawan/karyawanHomePage.dart';
import 'package:toko_kondang_jaya_snack/screens/kasir/kasirHomePage.dart';
import 'package:toko_kondang_jaya_snack/screens/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        AdminHomePage.routeName: (context) => AdminHomePage(),
        KasirHomePage.routeName: (context) => KasirHomePage(),
        KaryawanHomePage.routeName: (context) => KaryawanHomePage(),
        GuestHomePage.routeName: (context) => GuestHomePage(),
        MapScreen.routeName: (context) => MapScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      Navigator.pushNamed(context, LoginPage.routeName);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.inventory,
              size: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
              ),
              child: Text(
                'Welcome to ${AppConstants.appName}!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
