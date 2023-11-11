import 'dart:async';
import 'package:events/screens/navigation_screen.dart';
import 'package:events/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';

class OneScreen extends StatefulWidget {
  const OneScreen({super.key});

  @override
  State<OneScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<OneScreen> {
  LatLng? destLocation = const LatLng(37.3161, -121.9195);
  Location location = Location();
  loc.LocationData? _currentPosition;
  final Completer<GoogleMapController?> _controller = Completer();
  String? _address;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Uber'),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.navigate_next),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => NavigationScreen(
                            lng: destLocation!.longitude,
                            lat: destLocation!.latitude,
                          )),
                  (route) => false);
            }),
        body: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition:
                  CameraPosition(target: destLocation!, zoom: 16),
              onCameraMove: (CameraPosition? position) {
                if (destLocation != position!.target) {
                  setState(() {
                    destLocation = position.target;
                  });
                }
              },
              onCameraIdle: () {
                print("camera idle");
                _controller.future.then((GoogleMapController? controller) {
                  controller
                      ?.getLatLng(ScreenCoordinate(x: 0, y: 0))
                      .then((LatLng latLng) {
                    print(
                        "Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}");
                    getAddressFromLatLng(latLng.latitude, latLng.longitude);
                  });
                });
              },
              onTap: (latLng) {
                print(latLng);
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: Image.asset(
                  'assets/images/pin.png',
                  height: 45,
                  width: 45,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.white),
                padding: const EdgeInsets.all(20),
                child: Text(
                  _address ?? "Pick your destination address",
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            )
          ],
        ));
  }

  getAddressFromLatLng(double latitude, double longitude) async {
    try {
      // print(destLocation!.latitude);
      // print(destLocation!.longitude);
      // GeoData data = await Geocoder2.getDataFromCoordinates(
      //   latitude: destLocation!.latitude,
      //   longitude: destLocation!.longitude,
      //   googleMapApiKey: "AIzaSyDzA0Xd9COWOVmRQtbhDioaDv6zotqdiqg",
      // );
      GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: latitude,
        longitude: longitude,
        googleMapApiKey: "AIzaSyDzA0Xd9COWOVmRQtbhDioaDv6zotqdiqg",
      );
      print("Data latitude is ${data.latitude}");
      print("Data longitude is ${data.longitude}");
      print("Data city is ${data.city}");
      print("Data country is ${data.country}");
      print("Data address is ${data.address}");
      print("Data state is ${data.state}");
      setState(() {
        print("Inside setState, setting _address = data.address");

        _address = data.address;
      });
    } catch (e) {
      print("The error in getAddressFromLatLng is: $e");
      showSnackBar(e.toString(), context);
    }
  }

  getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    final GoogleMapController? controller = await _controller.future;

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted == await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    if (_permissionGranted == loc.PermissionStatus.granted) {
      location.changeSettings(accuracy: loc.LocationAccuracy.high);

      _currentPosition = await location.getLocation();
      print("The current position is $_currentPosition");
      if (_currentPosition != null) {
        controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
                _currentPosition!.latitude!, _currentPosition!.longitude!),
            zoom: 16)));
        setState(() {
          print(
              "Inside setState, setting destLocation = ${_currentPosition!.latitude!}, ${_currentPosition!.longitude!}");
          destLocation =
              LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
        });
      }
    }
  }
}
