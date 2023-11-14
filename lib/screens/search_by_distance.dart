import 'package:flutter/material.dart';

class SearchByDistance extends StatefulWidget {
  const SearchByDistance({super.key});

  @override
  State<SearchByDistance> createState() => _SearchByDistanceState();
}

class _SearchByDistanceState extends State<SearchByDistance> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Search by distance"),
    );
  }
}
