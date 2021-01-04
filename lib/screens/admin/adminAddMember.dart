import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminAddMember extends StatefulWidget {
  @override
  _AdminAddMemberState createState() => _AdminAddMemberState();
}

class _AdminAddMemberState extends State<AdminAddMember> {
  Map<String, dynamic> _data = {};

  final List<String> _role = [
    'Kasir',
    'Karyawan',
    'Member',
  ];

  String _roleId;

  Future<void> _submit(BuildContext context) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _data['email'], password: _data['password'])
        .then((firebase) async {
      String userID = firebase.user.uid;

      await FirebaseFirestore.instance.doc('users/${userID}').set(_data);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Member'),
        elevation: 5.0,
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _submit(context),
        child: Icon(Icons.save),
      ),
    );
  }

  String _getRoleText(String role) {
    if (role == 'Kasir') {
      return 'kasir';
    } else if (role == 'Karyawan') {
      return 'karyawan';
    } else {
      return 'Member';
    }
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      TextField(
        decoration: InputDecoration(labelText: 'Full Name'),
        onChanged: (value) {
          setState(() {
            _data['name'] = value;
          });
        },
      ),
      SizedBox(height: 8.0),
      DropdownButton(
        isExpanded: true,
        value: _roleId,
        hint: Text('Pilih Role'),
        items: _role.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _data['role'] = _getRoleText(value);
            _roleId = value;
          });
        },
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      onChanged: (value) {
        setState(() {
          _data['password'] = value;
        });
      },
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        setState(() {
          _data['email'] = value;
        });
      },
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
