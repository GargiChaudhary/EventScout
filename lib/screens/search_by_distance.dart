import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/model/event.dart';
import 'package:events/screens/event_details_page.dart';
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

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Handle case when location services are not enabled
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

  double maxDistance = 0;

  Future<List<Map<String, dynamic>>> _getFilteredEvents() async {
    final eventsCollection = FirebaseFirestore.instance.collection('events');

    // Fetch all events from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await eventsCollection.get();

    // Filter events based on distance
    List<Map<String, dynamic>> filteredEvents = [];
    querySnapshot.docs.forEach((eventDoc) {
      // Access event data as a map
      Map<String, dynamic> eventData = eventDoc.data() ?? {};

      double eventLatitude = eventData['latitude'] ?? 0.0;
      double eventLongitude = eventData['longitude'] ?? 0.0;
      print("Event lat is: $eventLatitude");
      print("Event long is: $eventLongitude");

      double distance = Geolocator.distanceBetween(
        userLat!,
        userLng!,
        eventLatitude,
        eventLongitude,
      );
      print("The distance between is: $distance");
      if (distance <= maxDistance * 1000) {
        filteredEvents.add(eventData);
      }
    });

    return filteredEvents;
  }

  // print("Event lat is: $eventLatitude");
  // print("Event long is: $eventLongitude");
  // print("The distance between is: $distance");

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
                // textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: 20),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          maxDistance = 0;
                        });
                        // print("max dis is: $maxDistance");
                      },
                      child: const MyButton(text: "All events")),
                  InkWell(
                      onTap: () {
                        setState(() {
                          maxDistance = 10;
                        });
                        // print("max dis is: $maxDistance");
                      },
                      child: const MyButton(text: "10 km")),
                  InkWell(
                      onTap: () {
                        setState(() {
                          maxDistance = 50;
                        });
                        // print("max dis is: $maxDistance");
                      },
                      child: const MyButton(text: "50 km")),

                  // ElevatedButton(
                  //   style: ButtonStyle(
                  //       backgroundColor: MaterialStatePropertyAll(
                  //           Theme.of(context).focusColor)),
                  //   child: Text(
                  //     "70 km",
                  //     style: TextStyle(
                  //         fontFamily: 'Montserrat',
                  //         fontSize: 13,
                  //         fontWeight: FontWeight.w500,
                  //         color: Theme.of(context).hintColor),
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       maxDistance = 70;
                  //     });
                  //   },
                  // ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        // print("max dis is: $maxDistance");
                      },
                      child: const MyButton(text: "100 km")),
                  InkWell(
                      onTap: () {
                        setState(() {
                          maxDistance = 200;
                        });
                        // print("max dis is: $maxDistance");
                      },
                      child: const MyButton(text: "200 km")),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          maxDistance = 300;
                        });
                        // print("max dis is: $maxDistance");
                      },
                      child: const MyButton(text: "300 km")),
                  InkWell(
                      onTap: () {
                        setState(() {
                          maxDistance = 500;
                        });
                        // print("max dis is: $maxDistance");
                      },
                      child: const MyButton(text: "500 km")),
                ],
              ),
              // 10 , 50 , 70
              // 100, 200, 300,
              // 500 , all
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 0.2,
              ),

              SingleChildScrollView(
                child: FutureBuilder(
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
                      return ListView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          // DocumentSnapshot eventDoc =
                          //     (snapshot.data! as dynamic).docs[index];
                          // DocumentSnapshot<Object?> eventDoc =
                          //     snapshot.data![index];

                          DateTime eventDate = DateFormat('yyyy-MM-dd').parse(
                              (snapshot.data! as dynamic).docs[index]
                                  ['duration']);
                          return InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => EventDetailsPage(
                                        event: Event.fromSnap(
                                            (snapshot.data! as dynamic)
                                                .docs[index][index])))),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                // color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Theme.of(context).shadowColor.withOpacity(0.3),
                                //     spreadRadius: 0.2,
                                //     blurRadius: 3,
                                //     offset: const Offset(0, 3),
                                //   )
                                // ],
                                // border: Border.all(
                                //   color: Theme.of(context).shadowColor.withOpacity(0.5),
                                //   width: 0.6,
                                // ),
                                // borderRadius: BorderRadius.circular(8)
                                border: Border.all(
                                    width: 0.5,
                                    color: Theme.of(context)
                                        .hintColor
                                        .withAlpha(80)),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withAlpha(100),
                                    blurRadius: 10.0,
                                    spreadRadius: 0.0,
                                  ),
                                ],
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.2),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          capitalizeAllWord(
                                              (snapshot.data! as dynamic)
                                                  .docs[index]['title']),
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Theme.of(context).hintColor),
                                          softWrap: true,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 15,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Flexible(
                                              child: Text(
                                                capitalizeAllWord(
                                                    (snapshot.data! as dynamic)
                                                            .docs[index]
                                                        ['location']),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .hintColor),
                                                softWrap: true,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Theme.of(context).primaryColor),
                                    ),
                                    onPressed: () {},
                                    child: FittedBox(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            calculateTimeLeft(eventDate),
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .hintColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
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
