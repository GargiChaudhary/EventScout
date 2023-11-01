// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/model/event.dart';
import 'package:events/resources/storage_methods.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadEvent(
      String title,
      Uint8List file,
      String uid,
      String description,
      String username,
      String profImage,
      String bio,
      String location,
      String duration,
      String punchLine,
      List categoryIds,
      List<String> galleryImages) async {
    String res = "some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('events', file, true);
      print("THE PHOTOURL IS::::::: $photoUrl :::::: END");
      String eventId = const Uuid().v1();
      print("THE EVENTID IS::::::: $eventId :::::: END");
      print("THE title IS::::::: $title :::::: END");
      print("THE uid IS::::::: $uid :::::: END");
      print("THE username IS::::::: $username :::::: END");
      print("THE profImage IS::::::: $profImage :::::: END");
      print("THE bio IS::::::: $bio :::::: END");
      print("THE description IS::::::: $description :::::: END");
      print("THE location IS::::::: $location :::::: END");
      print("THE duration IS::::::: $duration :::::: END");
      print("THE categoryIds IS::::::: $categoryIds :::::: END");
      print("THE galleryImages IS::::::: $galleryImages :::::: END");
      Event event = Event(
          title: title,
          uid: uid,
          username: username,
          eventId: eventId,
          datePublished: DateTime.now(),
          profImage: profImage,
          bio: bio,
          description: description,
          location: location,
          duration: duration,
          punchLine: punchLine,
          categoryIds: categoryIds,
          galleryImages: galleryImages,
          eventUrl: photoUrl);

      _firestore.collection('events').doc(eventId).set(event.toJson());
      print("uploaded event to firebase");
      // _firestore
      //     .collection('events')
      //     .doc(eventId)
      //     .set(event.toJson())
      //     .then((_) {
      //   print("Uploaded event to Firestore");
      // }).catchError((error) {
      //   print("Firestore Error: $error");
      // });
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
