import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Uint8List? _file;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _punchLineController = TextEditingController();
  final List categoryIds = [];
  final bool _isLoading = false;

  List<File> galleryImages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 5,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Add your event!!!",
          style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat'),
        ),
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).hintColor,
            )),
        actions: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  // onPressed: () => postEvent(ourUser.uid, ourUser.username,
                  //     ourUser.photoUrl, ourUser.bio),
                  onPressed: () {},
                  icon: Icon(
                    Icons.check,
                    color: Theme.of(context).hintColor,
                  )),
              Text(
                'Post',
                style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat'),
              )
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0)),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).shadowColor.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _titleController,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "Event title",
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                              contentPadding: const EdgeInsets.all(8),
                            ),
                          ),
                          TextField(
                            controller: _titleController,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                            decoration: InputDecoration(
                              hintText: "Event subtitle",
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                              contentPadding: const EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).shadowColor.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 6,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Theme.of(context).hintColor,
                            fontSize: 13),
                        decoration: InputDecoration(
                          hintText: "Event description",
                          hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Theme.of(context).hintColor,
                              fontSize: 13),
                          contentPadding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).shadowColor.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                            controller: _durationController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              hintText: "Date",
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                ),
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime(2101),
                                  ).then((pickedDate) {
                                    if (pickedDate != null) {
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      setState(() {
                                        _durationController.text =
                                            formattedDate;
                                      });
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          TextField(
                            controller: _titleController,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                            decoration: InputDecoration(
                              hintText: "Event subtitle",
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                              contentPadding: const EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
