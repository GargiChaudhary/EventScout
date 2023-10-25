import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title,
      description,
      location,
      duration,
      punchLine,
      uid,
      username,
      bio,
      eventId,
      eventUrl,
      profImage;
  final datePublished;
  final List categoryIds, galleryImages;

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
      required this.location,
      required this.duration,
      required this.punchLine,
      required this.categoryIds,
      required this.galleryImages});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "bio": bio,
        "title": title,
        "description": description,
        "location": location,
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
      location: snapshot['location'],
      duration: snapshot['duration'],
      punchLine: snapshot['punchLine'],
      categoryIds: snapshot['categoryIds'],
      galleryImages: snapshot['galleryImages'],
      uid: snapshot['categoryIds'],
      username: snapshot['username'],
      eventUrl: snapshot['eventUrl'],
      eventId: snapshot['eventId'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      bio: snapshot['bio'],
    );
  }
}

Future<List<Event>?> fetchAllEvents() async {
  List<Event> events = [];
  try {
    QuerySnapshot eventQuery =
        await FirebaseFirestore.instance.collection('events').get();
    eventQuery.docs.forEach((eventDoc) {
      Event event = Event.fromSnap(eventDoc);
      events.add(event);
    });
  } catch (e) {
    print("Error fetching events: $e");
  }
  return events;
}

// final fiveKmRunEvent = Event(
//     imagePath: "assets/event_images/5_km_downtown_run.jpeg",
//     title: "5 Kilometer Downtown Run",
//     description: "",
//     location: "Pleasant Park",
//     duration: "3h",
//     punchLine: "Marathon!",
//     galleryImages: [],
//     categoryIds: [0, 1]);

// final cookingEvent = Event(
//     imagePath: "assets/event_images/granite_cooking_class.jpeg",
//     title: "Granite Cooking Class",
//     description:
//         "Guest list fill up fast so be sure to apply before handto secure a spot.",
//     location: "Food Court Avenue",
//     duration: "4h",
//     punchLine: "Granite Cooking",
//     categoryIds: [
//       0,
//       2
//     ],
//     galleryImages: [
//       "assets/event_images/cooking_1.jpeg",
//       "assets/event_images/cooking_2.jpeg",
//       "assets/event_images/cooking_3.jpeg"
//     ]);

// final musicConcert = Event(
//     imagePath: "assets/event_images/music_concert.jpeg",
//     title: "Arijit Music Concert",
//     description: "Listen to Arijit's latest compositions.",
//     location: "D.Y. Patil Stadium, Mumbai",
//     duration: "5h",
//     punchLine: "Music Lovers!",
//     galleryImages: [
//       "assets/event_images/cooking_1.jpeg",
//       "assets/event_images/cooking_2.jpeg",
//       "assets/event_images/cooking_3.jpeg"
//     ],
//     categoryIds: [
//       0,
//       1
//     ]);

// final golfCompetition = Event(
//     imagePath: "assets/event_images/golf_competition.jpeg",
//     title: "Season 2 Golf Estate",
//     description: "",
//     location: "NSIC Ground, Okhla",
//     duration: "1d",
//     punchLine: "The latest fad in foodology, get the inside scoup.",
//     galleryImages: [
//       "assets/event_images/cooking_1.jpeg",
//       "assets/event_images/cooking_2.jpeg",
//       "assets/event_images/cooking_3.jpeg"
//     ],
//     categoryIds: [
//       0,
//       3
//     ]);

// final events = [
//   fiveKmRunEvent,
//   cookingEvent,
//   musicConcert,
//   golfCompetition,
// ];

// import 'package:cloud_firestore/cloud_firestore.dart';

// class OurUser {
//   final String username;
//   final String email;
//   final String uid;
//   final String photoUrl;
//   final String bio;

//   const OurUser(
//       {required this.username,
//       required this.email,
//       required this.uid,
//       required this.photoUrl,
//       required this.bio});

//   Map<String, dynamic> toJson() => {
//         "username": username,
//         "uid": uid,
//         "email": email,
//         "photoUrl": photoUrl,
//         "bio": bio,
//       };

//   static OurUser fromSnap(DocumentSnapshot snap) {
//     var snapshot = snap.data() as Map<String, dynamic>;
//     return OurUser(
//       username: snapshot['username'],
//       email: snapshot['email'],
//       uid: snapshot['uid'],
//       photoUrl: snapshot['photoUrl'],
//       bio: snapshot['bio'],
//     );
//   }
// }
// 3YT5ZUIWEUPUM 

