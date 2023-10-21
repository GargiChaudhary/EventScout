import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/model/our_user.dart';
import 'package:events/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<OurUser> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return OurUser.fromSnap(snap);
  }

  // sign up method
  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // ignore: avoid_print
        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePic', file, false);

        //add user to our database

        OurUser ourUser = OurUser(
            username: username,
            email: email,
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            bio: bio);

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(ourUser.toJson());

        res = "success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // log in user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
