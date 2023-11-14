import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/model/event.dart';
import 'package:events/screens/event_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  bool isShowEvent = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Container(
          margin: EdgeInsets.symmetric(
            horizontal: width > 600 ? width * 0.3 : 0,
            vertical: width > 600 ? 15 : 5,
          ),
          child: TextFormField(
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
            onFieldSubmitted: (String _) {
              setState(() {
                isShowEvent = true;
              });
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isShowEvent = false;
                  });
                },
                child: const Text('Users'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isShowEvent = true;
                  });
                },
                child: const Text('Events'),
              ),
            ],
          ),
          FutureBuilder(
            future: searchController.text.isEmpty
                ? Future.value(null)
                : isShowEvent
                    ? FirebaseFirestore.instance
                        .collection('events')
                        .where('title',
                            isGreaterThanOrEqualTo: searchController.text)
                        .get()
                    : FirebaseFirestore.instance
                        .collection('users')
                        .where('username',
                            isGreaterThanOrEqualTo: searchController.text)
                        .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                if (searchController.text.isEmpty || snapshot.data == null) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: SvgPicture.asset(
                        'assets/images/search.svg',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  );
                }
                if (isShowEvent) {
                  return buildEventResults(snapshot);
                } else {
                  return buildUserResults(snapshot);
                }
              }
              // return SizedBox(
              //   width:100,
              //   height: 100,
              //   child: Text("data"),);
            },
          )
        ],
      ),
      // body: isShowEvent
      //     ? FutureBuilder(
      //         future: FirebaseFirestore.instance
      //             .collection('events')
      //             .where('title',
      //                 isGreaterThanOrEqualTo: searchController.text)
      //             .get(),
      //         builder: (context, snapshot) {
      //           if (!snapshot.hasData) {
      //             return const Center(child: CircularProgressIndicator());
      //           }
      //           return ListView.builder(
      //             itemCount: (snapshot.data! as dynamic).docs.length,
      //             itemBuilder: (context, index) {
      //               DateTime eventDate = DateFormat('yyyy-MM-dd').parse(
      //                   (snapshot.data! as dynamic).docs[index]['duration']);
      //               return InkWell(
      //                 onTap: () => Navigator.of(context).push(
      //                     MaterialPageRoute(
      //                         builder: (context) => EventDetailsPage(
      //                             event: Event.fromSnap(
      //                                 snapshot.data!.docs[index])))),
      //                 child: Container(
      //                   margin: const EdgeInsets.symmetric(
      //                       horizontal: 10, vertical: 5),
      //                   padding: const EdgeInsets.symmetric(
      //                       horizontal: 10, vertical: 5),
      //                   decoration: BoxDecoration(
      //                       color: Theme.of(context)
      //                           .scaffoldBackgroundColor
      //                           .withOpacity(0.9),
      //                       boxShadow: [
      //                         BoxShadow(
      //                           color: Theme.of(context)
      //                               .shadowColor
      //                               .withOpacity(0.3),
      //                           spreadRadius: 0.2,
      //                           blurRadius: 3,
      //                           offset: const Offset(0, 3),
      //                         )
      //                       ],
      //                       border: Border.all(
      //                         color: Theme.of(context)
      //                             .shadowColor
      //                             .withOpacity(0.5),
      //                         width: 0.6,
      //                       ),
      //                       borderRadius: BorderRadius.circular(8)),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       SizedBox(
      //                         width: MediaQuery.of(context).size.width * 0.4,
      //                         child: Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             Text(
      //                               capitalizeAllWord(
      //                                   (snapshot.data! as dynamic)
      //                                       .docs[index]['title']),
      //                               style: TextStyle(
      //                                   fontFamily: 'Montserrat',
      //                                   fontSize: 16,
      //                                   fontWeight: FontWeight.w600,
      //                                   color: Theme.of(context).hintColor),
      //                               softWrap: true,
      //                             ),
      //                             Row(
      //                               children: [
      //                                 const Icon(
      //                                   Icons.location_on,
      //                                   size: 15,
      //                                   color: Colors.red,
      //                                 ),
      //                                 const SizedBox(
      //                                   width: 5,
      //                                 ),
      //                                 Flexible(
      //                                   child: Text(
      //                                     capitalizeAllWord(
      //                                         (snapshot.data! as dynamic)
      //                                             .docs[index]['location']),
      //                                     style: TextStyle(
      //                                         fontWeight: FontWeight.w500,
      //                                         fontFamily: 'Montserrat',
      //                                         fontSize: 13,
      //                                         color: Theme.of(context)
      //                                             .hintColor),
      //                                     softWrap: true,
      //                                   ),
      //                                 )
      //                               ],
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                       ElevatedButton(
      //                         style: ButtonStyle(
      //                           backgroundColor:
      //                               MaterialStateProperty.all<Color>(
      //                                   Theme.of(context).primaryColor),
      //                         ),
      //                         onPressed: () {},
      //                         child: FittedBox(
      //                           child: Row(
      //                             children: [
      //                               Icon(
      //                                 Icons.access_time,
      //                                 size: 14,
      //                                 color: Theme.of(context).hintColor,
      //                               ),
      //                               const SizedBox(
      //                                 width: 5,
      //                               ),
      //                               Text(
      //                                 calculateTimeLeft(eventDate),
      //                                 style: TextStyle(
      //                                     fontFamily: 'Montserrat',
      //                                     fontSize: 13,
      //                                     color: Theme.of(context).hintColor),
      //                               )
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               );
      //             },
      //           );
      //         },
      //       )
      //     : Center(
      //         child: Container(
      //           padding: const EdgeInsets.all(20),
      //           child: SvgPicture.asset(
      //             'assets/images/search.svg',
      //             height: 100,
      //             width: 100,
      //           ),
      //         ),
      //       )
    );
  }
}

Widget buildEventResults(AsyncSnapshot snapshot) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: (snapshot.data! as dynamic).docs.length,
    itemBuilder: (context, index) {
      DateTime eventDate = DateFormat('yyyy-MM-dd')
          .parse((snapshot.data! as dynamic).docs[index]['duration']);
      return InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventDetailsPage(
                event: Event.fromSnap(snapshot.data!.docs[index])))),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
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
                      capitalizeAllWord(
                          (snapshot.data! as dynamic).docs[index]['title']),
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
        ),
      );
    },
  );
}

Widget buildUserResults(AsyncSnapshot snapshot) {
  return Container(
    width: 400,
    height: 400,
    padding: const EdgeInsets.all(10),
    child: const Text("showing users"),
  );
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
