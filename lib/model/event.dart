import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title,
      description,
      address,
      punchLine,
      uid,
      username,
      bio,
      eventId,
      eventUrl,
      profImage;
  final duration;
  final datePublished;
  final double latitude;
  final double longitude;
  final List<int> categoryIds;
  final List<String> galleryImages;

  Event(
      {required this.title,
      required this.uid,
      required this.username,
      required this.eventId,
      required this.datePublished,
      required this.profImage,
      required this.bio,
      required this.description,
      required this.eventUrl,
      required this.address,
      required this.duration,
      required this.punchLine,
      required this.categoryIds,
      required this.latitude,
      required this.longitude,
      required this.galleryImages});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "bio": bio,
        "title": title,
        "description": description,
        "address": address,
        "duration": duration,
        "punchLine": punchLine,
        "categoryIds": categoryIds,
        "galleryImages": galleryImages,
        "eventUrl": eventUrl,
        "eventId": eventId,
        "datePublished": datePublished,
        "profImage": profImage,
      };

  static Event fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Event(
      title: snapshot['title'],
      description: snapshot['description'],
      address: snapshot['address'],
      duration: snapshot['duration'],
      punchLine: snapshot['punchLine'],
      categoryIds: snapshot['categoryIds'].cast<int>(),
      galleryImages: snapshot['galleryImages'].cast<String>(),
      uid: snapshot['uid'],
      username: snapshot['username'],
      eventUrl: snapshot['eventUrl'],
      eventId: snapshot['eventId'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      bio: snapshot['bio'],
      latitude: snapshot['latitude'],
      longitude: snapshot['longitude'],
    );
  }
}

// 3YT5ZUIWEUPUM 

