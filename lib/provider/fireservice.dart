import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FireService extends ChangeNotifier {
  FirebaseAuth fireAuth = FirebaseAuth.instance;
  FirebaseFirestore fstorage = FirebaseFirestore.instance;

  Future<UserCredential> registerUser(
      String email, String pass, String name) async {
    try {
      UserCredential userCredential = await fireAuth
          .createUserWithEmailAndPassword(email: email, password: pass);

      try {
        await fstorage.collection("Users").doc(userCredential.user!.uid).set({
          "uid": userCredential.user!.uid,
          "email": userCredential.user!.email,
          "name": name
        }, SetOptions(merge: true));
      } on Exception catch (e) {
        if (kDebugMode) {
          print("addusererror $e");
        }
      }
      notifyListeners();

      return userCredential;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  void loginUser(String email, String pass) async {
    try {
      await fireAuth.signInWithEmailAndPassword(email: email, password: pass);
    } on Exception catch (e) {
      if (kDebugMode) {
        print("--------------------------------$e");
      }
    }
    notifyListeners();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
