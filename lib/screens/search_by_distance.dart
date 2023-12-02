import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/model/event.dart';
import 'package:events/screens/event_details_page.dart';
import 'package:events/utils/palette.dart';
import 'package:events/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as loc;
import 'package:intl/intl.dart';

class SearchByDistance extends StatefulWidget {
  const SearchByDistance({super.key});

  @override
  State<SearchByDistance> createState() => _SearchByDistanceState();
}

String calculateTimeLeft(DateTime eventDate) {
  final currentDate = DateTime.now();
  final difference = eventDate.difference(currentDate);

  if (difference.isNegative) {
    return "Expired";
  } else if (difference.inDays == 0) {
    return "Today";
  } else if (difference.inDays <= 30) {
    return "${difference.inDays} days left";
  } else {
    final monthsLeft = difference.inDays ~/ 30;
    // final daysLeft = difference.inDays % 30;

    return monthsLeft == 1
        ? "$monthsLeft month left"
        : "$monthsLeft months left";
  }
}

class _SearchByDistanceState extends State<SearchByDistance> {
  double? userLat;
  double? userLng;
  @override
  void initState() {
    print("Inside initstate function");
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    print("Inside getlocation function");
    bool serviceEnabled;
    loc.LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      const SnackBar(content: Text("Location services are disabled."));
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        const SnackBar(content: Text("Location permissions are denied."));
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      const SnackBar(
          content: Text(
              "Location permissions are permanently denied, we cannot request permissions."));
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLat = position.latitude;
      userLng = position.longitude;
      print("user lat is: $userLat");
      print("user long is: $userLng");
    });
  }

  double maxDistance = double.infinity;

  Future<List<Map<String, dynamic>>> _getFilteredEvents() async {
    final eventsCollection = FirebaseFirestore.instance.collection('events');

    // Fetch all events from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await eventsCollection.get();

    // Filter events based on distance
    List<Map<String, dynamic>> filteredEvents = [];
    querySnapshot.docs.forEach((eventDoc) {
      // Access event data as a map
      Map<String, dynamic> eventData = eventDoc.data();

      double eventLatitude = eventData['latitude'];
      double eventLongitude = eventData['longitude'];
      print("Event lat is: $eventLatitude");
      print("Event long is: $eventLongitude");

      double distance = Geolocator.distanceBetween(
        userLat!,
        userLng!,
        eventLatitude,
        eventLongitude,
      );
      print("The distance between is: $distance");
      if (distance <= maxDistance * 1000.0) {
        print("Inside this distance if");
        filteredEvents.add(eventData);
      }
    });

    return filteredEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Search events within",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          maxDistance = double.infinity;
                        });
                      },
                      child: const MyButton(text: "All events")),
                  InkWell(
                      onTap: () {
                        setState(() {
                          maxDistance = 10;
                        });
                      },
                      child: const MyButton(text: "10 km")),
                  InkWell(
                      onTap: () {
                        setState(() {
                          maxDistance = 50;
                        });
                      },
                      child: const MyButton(text: "50 km")),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          maxDistance = 70;
                        });
                      },
                      child: const MyButton(text: "70 km")),
                  InkWell(
                      onTap: () {
                        setState(() {
                          maxDistance = 100;
                        });
                      },
                      child: const MyButton(text: "100 km")),
                  InkWell(
                      onTap: () {
                        setState(() {
                          maxDistance = 200;
                        });
                      },
                      child: const MyButton(text: "200 km")),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          maxDistance = 300;
                        });
                      },
                      child: const MyButton(text: "300 km")),
                  InkWell(
                      onTap: () {
                        setState(() {
                          maxDistance = 500;
                        });
                      },
                      child: const MyButton(text: "500 km")),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 0.2,
              ),
              FutureBuilder(
                future: _getFilteredEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('No events within $maxDistance km'));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> eventData =
                              snapshot.data![index];
                          Event event = Event(
                            title: eventData['title'],
                            ticketPrice: eventData['ticketPrice'],
                            upiId: eventData['upiId'],
                            uid: eventData['uid'],
                            username: eventData['username'],
                            eventId: eventData['eventId'],
                            datePublished: eventData['datePublished'],
                            profImage: eventData['profImage'],
                            bio: eventData['bio'],
                            description: eventData['description'],
                            eventUrl: eventData['eventUrl'],
                            location: eventData['location'],
                            duration: eventData['duration'],
                            punchLine: eventData['punchLine'],
                            latitude: eventData['latitude'],
                            longitude: eventData['longitude'],
                            categoryIds: eventData['categoryIds'].cast<int>(),
                            galleryImages:
                                eventData['galleryImages'].cast<String>(),
                          );
                          DateTime eventDate = DateFormat('yyyy-MM-dd')
                              .parse(eventData['duration']);

                          return InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EventDetailsPage(event: event))),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.3),
                                          width: 0.2))),
                              child: Row(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                eventData['eventUrl']))),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          capitalizeAllWord(
                                            eventData['title'],
                                          ),
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 15,
                                              color: Palette.myPink.shade900,
                                              fontWeight: FontWeight.w600),
                                          softWrap: true,
                                        ),
                                        Text(
                                          capitalizeFirstWord(
                                              eventData['punchLine']),
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 12,
                                            color: Theme.of(context).hintColor,
                                          ),
                                          softWrap: true,
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '\u{20B9}${eventData['ticketPrice']}',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .hintColor),
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  size: 13,
                                                  color:
                                                      Palette.myPink.shade900,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  calculateTimeLeft(eventDate),
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 13,
                                                      color: Theme.of(context)
                                                          .hintColor),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String capitalizeAllWord(String value) {
  var result = value[0].toUpperCase();
  for (int i = 1; i < value.length; i++) {
    if (value[i - 1] == " ") {
      result = result + value[i].toUpperCase();
    } else {
      result = result + value[i];
    }
  }
  return result;
}

String capitalizeFirstWord(String value) {
  var result = value[0].toUpperCase();
  for (int i = 1; i < value.length; i++) {
    result = result + value[i];
  }

  return result;
}
