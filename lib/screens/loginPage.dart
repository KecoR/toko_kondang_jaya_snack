import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toko_kondang_jaya_snack/models/appConstants.dart';
import 'package:toko_kondang_jaya_snack/models/userObjects.dart';
import 'package:toko_kondang_jaya_snack/screens/admin/adminHomePage.dart';
import 'package:toko_kondang_jaya_snack/screens/guest/guestHomePage.dart';
import 'package:toko_kondang_jaya_snack/screens/karyawan/karyawanHomePage.dart';
import 'package:toko_kondang_jaya_snack/screens/kasir/kasirHomePage.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = '/loginPageRoute';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((firebaseUser) {
        String userID = firebaseUser.user.uid;
        AppConstants.currentUser = UserData(id: userID);
        AppConstants.currentUser
            .getPersonalInfoFromFirestore()
            .whenComplete(() {
          if (AppConstants.currentUser.role == 'admin') {
            Navigator.pushNamed(context, AdminHomePage.routeName);
          } else if (AppConstants.currentUser.role == 'kasir') {
            Navigator.pushNamed(context, KasirHomePage.routeName);
          } else if (AppConstants.currentUser.role == 'karyawan') {
            Navigator.pushNamed(context, KaryawanHomePage.routeName);
          } else if (AppConstants.currentUser.role == 'Member') {
            Navigator.pushNamed(context, GuestHomePage.routeName);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 100, 50, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Welcome to ${AppConstants.appName}!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 35.0,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                          controller: _emailController,
                          validator: (text) {
                            if (!text.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                          ),
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                          controller: _passwordController,
                          validator: (text) {
                            if (text.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: MaterialButton(
                    onPressed: () {
                      _login();
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.blue,
                    height: MediaQuery.of(context).size.height / 12,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
