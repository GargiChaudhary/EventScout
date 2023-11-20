import 'package:events/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as loc;

class SearchByDistance extends StatefulWidget {
  const SearchByDistance({super.key});

  @override
  State<SearchByDistance> createState() => _SearchByDistanceState();
}

Future<Position> getLocation() async {
  bool serviceEnabled;
  loc.LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Handle case when location services are not enabled
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}

class _SearchByDistanceState extends State<SearchByDistance> {
  double? userLat;
  double? userLng;
  @override
  void initState() {
    getLocation().then((value) {
      userLat = value.latitude;
      userLng = value.longitude;
    });
    super.initState();
  }

  double maxDistance = 0;

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
            ],
          ),
        ),
      ),
    );
  }
}
