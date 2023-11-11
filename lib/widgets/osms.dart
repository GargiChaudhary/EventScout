// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'package:events/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OpenStreetMapSearchAndPick extends StatefulWidget {
  final LatLong center;
  final void Function(PickedData pickedData) onPicked;
  final Future<LatLng> Function() onGetCurrentLocationPressed;
  final IconData zoomInIcon;
  final IconData zoomOutIcon;
  final IconData currentLocationIcon;
  final IconData locationPinIcon;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color locationPinIconColor;
  final String locationPinText;
  final TextStyle locationPinTextStyle;
  final String buttonText;
  final String hintText;
  final double buttonHeight;
  final double buttonWidth;
  final TextStyle buttonTextStyle;
  final String baseUri;

  static Future<LatLng> nopFunction() {
    throw Exception("");
  }

  const OpenStreetMapSearchAndPick(
      {Key? key,
      this.center = const LatLong(0, 0),
      // this.center = const LatLong(28.7041, 77.1025),
      required this.onPicked,
      this.zoomOutIcon = Icons.zoom_out_rounded,
      this.zoomInIcon = Icons.zoom_in_rounded,
      this.currentLocationIcon = Icons.my_location,
      this.onGetCurrentLocationPressed = nopFunction,
      this.buttonColor = const Color(0xfff6a192),
      this.locationPinIconColor = const Color(0xfff6a192),
      this.locationPinText = 'Pin on your location',
      this.locationPinTextStyle = const TextStyle(
          fontSize: 14,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Color(0xFFF47D68)),
      this.hintText = 'Search Location',
      this.buttonTextStyle = const TextStyle(
          fontSize: 14,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.white),
      this.buttonTextColor = Colors.white,
      this.buttonText = 'Done',
      this.buttonHeight = 50,
      this.buttonWidth = 200,
      this.baseUri = 'https://nominatim.openstreetmap.org',
      this.locationPinIcon = Icons.location_on})
      : super(key: key);

  @override
  State<OpenStreetMapSearchAndPick> createState() =>
      _OpenStreetMapSearchAndPickState();
}

class _OpenStreetMapSearchAndPickState
    extends State<OpenStreetMapSearchAndPick> {
  MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<OSMdata> _options = <OSMdata>[];
  Timer? _debounce;
  var client = http.Client();

  void setNameCurrentPos() async {
    double latitude = _mapController.center.latitude;
    double longitude = _mapController.center.longitude;
    if (kDebugMode) {
      print(latitude);
    }
    if (kDebugMode) {
      print(longitude);
    }
    String url =
        '${widget.baseUri}/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1';

    var response = await client.get(Uri.parse(url));
    // var response = await client.post(Uri.parse(url));
    var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;

    _searchController.text =
        decodedResponse['display_name'] ?? "MOVE TO CURRENT POSITION";
    setState(() {});
  }

  void setNameCurrentPosAtInit() async {
    double latitude = widget.center.latitude;
    double longitude = widget.center.longitude;
    if (kDebugMode) {
      print(latitude);
    }
    if (kDebugMode) {
      print(longitude);
    }

    String url =
        '${widget.baseUri}/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1';

    var response = await client.get(Uri.parse(url));
    // var response = await client.post(Uri.parse(url));
    var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;

    _searchController.text =
        decodedResponse['display_name'] ?? "MOVE TO CURRENT POSITION";
    setState(() {});
  }

  @override
  void initState() {
    _mapController = MapController();

    // setNameCurrentPosAtInit();

    // _mapController.mapEventStream.listen((event) async {
    //   if (event is MapEventMoveEnd) {
    //     var client = http.Client();
    //     String url =
    //         '${widget.baseUri}/reverse?format=json&lat=${event.center.latitude}&lon=${event.center.longitude}&zoom=18&addressdetails=1';

    //     var response = await client.get(Uri.parse(url));
    //     // var response = await client.post(Uri.parse(url));
    //     var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes))
    //         as Map<dynamic, dynamic>;

    //     _searchController.text = decodedResponse['display_name'];
    //     setState(() {});
    //   }
    // });

    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
              child: FlutterMap(
            options: MapOptions(
                center: LatLng(widget.center.latitude, widget.center.longitude),
                zoom: 15.0,
                maxZoom: 18,
                minZoom: 6),
            mapController: _mapController,
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
                // attributionBuilder: (_) {
                //   return Text("© OpenStreetMap contributors");
                // },
              ),
            ],
          )),
          Positioned.fill(
              child: IgnorePointer(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.locationPinText,
                      style: widget.locationPinTextStyle,
                      textAlign: TextAlign.center),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    // child: Icon(
                    //   widget.locationPinIcon,
                    //   size: 50,
                    //   color: widget.locationPinIconColor,
                    // ),
                    child: Image.asset(
                      'assets/images/pin.png',
                      height: 45,
                      width: 45,
                    ),
                  ),
                ],
              ),
            ),
          )),
          Positioned(
              bottom: 180,
              right: 5,
              child: FloatingActionButton(
                heroTag: 'btn1',
                backgroundColor: const Color(0xfff6a192),
                onPressed: () {
                  _mapController.move(
                      _mapController.center, _mapController.zoom + 1);
                },
                child: Icon(
                  widget.zoomInIcon,
                  color: Colors.black,
                ),
              )),
          Positioned(
              bottom: 120,
              right: 5,
              child: FloatingActionButton(
                heroTag: 'btn2',
                backgroundColor: widget.buttonColor,
                onPressed: () {
                  _mapController.move(
                      _mapController.center, _mapController.zoom - 1);
                },
                child: Icon(
                  widget.zoomOutIcon,
                  color: Colors.black,
                ),
              )),
          Positioned(
              bottom: 60,
              right: 5,
              child: FloatingActionButton(
                heroTag: 'btn3',
                backgroundColor: widget.buttonColor,
                onPressed: () async {
                  try {
                    LatLng position =
                        await widget.onGetCurrentLocationPressed.call();
                    _mapController.move(
                        LatLng(position.latitude, position.longitude),
                        _mapController.zoom);
                  } catch (e) {
                    _mapController.move(
                        LatLng(widget.center.latitude, widget.center.longitude),
                        _mapController.zoom);
                  } finally {
                    setNameCurrentPos();
                  }
                },
                child: Icon(
                  widget.currentLocationIcon,
                  color: Colors.black,
                ),
              )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(5),
              // ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withAlpha(80)),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withAlpha(100),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                  ),
                ],
                color: Colors.white.withOpacity(0.2),
              ),
              child: Column(
                children: [
                  TextFormField(
                      controller: _searchController,
                      style: const TextStyle(
                        color: blackColor,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                      ),
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: const TextStyle(
                            color: blackColor,
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                          )
                          // border: inputBorder,
                          // focusedBorder: inputFocusBorder,
                          ),
                      onChanged: (String value) {
                        if (_debounce?.isActive ?? false) _debounce?.cancel();

                        _debounce =
                            Timer(const Duration(milliseconds: 2000), () async {
                          if (kDebugMode) {
                            print(value);
                          }
                          var client = http.Client();
                          try {
                            String url =
                                '${widget.baseUri}/search?q=$value&format=json&polygon_geojson=1&addressdetails=1';
                            if (kDebugMode) {
                              print(url);
                            }
                            var response = await client.get(Uri.parse(url));
                            // var response = await client.post(Uri.parse(url));
                            var decodedResponse =
                                jsonDecode(utf8.decode(response.bodyBytes))
                                    as List<dynamic>;
                            if (kDebugMode) {
                              print(decodedResponse);
                            }
                            _options = decodedResponse
                                .map((e) => OSMdata(
                                    displayname: e['display_name'],
                                    lat: double.parse(e['lat']),
                                    lon: double.parse(e['lon'])))
                                .toList();
                            setState(() {});
                          } finally {
                            client.close();
                          }

                          setState(() {});
                        });
                      }),
                  StatefulBuilder(builder: ((context, setState) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _options.length > 5 ? 5 : _options.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_options[index].displayname),
                            subtitle: Text(
                                '${_options[index].lat},${_options[index].lon}'),
                            onTap: () {
                              _mapController.move(
                                  LatLng(
                                      _options[index].lat, _options[index].lon),
                                  15.0);

                              _focusNode.unfocus();
                              _searchController.text =
                                  _options[index].displayname;
                              _options.clear();

                              setState(() {});
                            },
                          );
                        });
                  })),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(primaryColor)),
                  child: const Text(
                    "Done",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  onPressed: () async {
                    pickData().then((value) {
                      widget.onPicked(value);
                    });
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<PickedData> pickData() async {
    LatLong center = LatLong(
        _mapController.center.latitude, _mapController.center.longitude);
    var client = http.Client();
    String url =
        '${widget.baseUri}/reverse?format=json&lat=${_mapController.center.latitude}&lon=${_mapController.center.longitude}&zoom=18&addressdetails=1';

    var response = await client.get(Uri.parse(url));
    // var response = await client.post(Uri.parse(url));
    var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;
    _searchController.text = decodedResponse['display_name'];
    String displayName = decodedResponse['display_name'];

    print(
        "Inside pickedData and the lat is ${center.latitude}, lon is : ${center.longitude}, and the displayname is : ${displayName}");
    return PickedData(center, displayName, decodedResponse["address"]);
  }
}

class OSMdata {
  final String displayname;
  final double lat;
  final double lon;
  OSMdata({required this.displayname, required this.lat, required this.lon});
  @override
  String toString() {
    return '$displayname, $lat, $lon';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is OSMdata && other.displayname == displayname;
  }

  @override
  int get hashCode => Object.hash(displayname, lat, lon);
}

class LatLong {
  final double latitude;
  final double longitude;
  const LatLong(this.latitude, this.longitude);
}

class PickedData {
  final LatLong latLong;
  final String addressName;
  final Map<String, dynamic> address;

  PickedData(this.latLong, this.addressName, this.address);
}
