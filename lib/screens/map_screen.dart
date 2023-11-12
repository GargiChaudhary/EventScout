import 'package:events/utils/colors.dart';
import 'package:events/widgets/osms.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choose Venue",
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: OpenStreetMapSearchAndPick(
          center: const LatLong(28.7041, 77.1025),
          buttonColor: primaryColor,
          buttonText: 'Done',
          onPicked: (pickedData) {
            Navigator.pop(context, {
              'address': pickedData.address,
              'latitude': pickedData.latLong.latitude,
              'longitude': pickedData.latLong.longitude,
            });
            print('Latitude : ${pickedData.latLong.latitude}');
            print('Longitude: ${pickedData.latLong.longitude}');
            print(pickedData.address);
          }),
    );
  }
}
