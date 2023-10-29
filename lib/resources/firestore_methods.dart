import 'dart:io';

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
      List<File> galleryImages) async {
    String res = "some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('events', file, true);

      String eventId = const Uuid().v1();

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
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
