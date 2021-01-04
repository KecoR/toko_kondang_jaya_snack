import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  DocumentSnapshot snapshot;
  String id;
  String name;
  String role;

  UserData({
    this.id,
    this.name,
    this.role,
  });

  Future<void> getPersonalInfoFromFirestore() async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(this.id).get();
    this.snapshot = snapshot;
    this.name = snapshot['name'] ?? "";
    this.role = snapshot['role'] ?? "";
  }
}
