import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUDService {
  User? user = FirebaseAuth.instance.currentUser;

  // add
  Future addContact(String name, String phone, String email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("contacts")
        .add({
      "name": name,
      "phone": phone,
      "email": email,
    });
  }

  // read
  Stream<QuerySnapshot> getContacts() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("contacts")
        .orderBy("name")
        .snapshots();
  }

  // update
  Future updateContact(String docID, String name, String phone, String email) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("contacts")
        .doc(docID)
        .update({
      "name": name,
      "phone": phone,
      "email": email,
    });
  }

  // delete
  Future deleteContact(String docID) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("contacts")
        .doc(docID)
        .delete();
  }
Future<bool> isContactExists(String phone) async {
  var snapshot = await FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection("contacts")
      .where("phone", isEqualTo: phone)
      .get();

  return snapshot.docs.isNotEmpty;
}
}