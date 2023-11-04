import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
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

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            label: Text(
              'Search for events',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          onFieldSubmitted: (value) {},
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('events')
            .where('title', isGreaterThanOrEqualTo: searchController.text)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) {
              DateTime eventDate = DateFormat('yyyy-MM-dd')
                  .parse((snapshot.data! as dynamic).docs[index]['duration']);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.3),
                        spreadRadius: 0.2,
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      )
                    ],
                    border: Border.all(
                      color: Theme.of(context).shadowColor.withOpacity(0.5),
                      width: 0.6,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capitalizeAllWord((snapshot.data! as dynamic)
                                .docs[index]['title']),
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).hintColor),
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
                                  capitalizeAllWord((snapshot.data! as dynamic)
                                      .docs[index]['location']),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat',
                                      fontSize: 13,
                                      color: Theme.of(context).hintColor),
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
                        backgroundColor: MaterialStateProperty.all<Color>(
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
                                  fontSize: 13,
                                  color: Theme.of(context).hintColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
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
