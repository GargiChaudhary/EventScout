import 'package:cloud_firestore/cloud_firestore.dart';

class OurUser {
  final String username;
  final String email;
  final String uid;
  final String photoUrl;
  final String bio;

  const OurUser(
      {required this.username,
      required this.email,
      required this.uid,
      required this.photoUrl,
      required this.bio});

  static OurUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return OurUser(
      username: snapshot['username'],
      email: snapshot['email'],
      uid: snapshot['uid'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
      };
}
