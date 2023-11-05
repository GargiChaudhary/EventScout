import 'package:events/model/event.dart';
import 'package:events/model/our_user.dart';
import 'package:events/providers/user_provider.dart';
import 'package:events/resources/firestore_methods.dart';
import 'package:events/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventWidget extends StatefulWidget {
  final Event event;
  const EventWidget({super.key, required this.event});

  @override
  State<EventWidget> createState() => _EventWidgetState();
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

class _EventWidgetState extends State<EventWidget> {
  deletePost(String eventId) async {
    try {
      await FirestoreMethods().deletePost(eventId);
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime eventDate = DateFormat('yyyy-MM-dd').parse(widget.event.duration);
    // return Card(
    //   margin: const EdgeInsets.symmetric(vertical: 15),
    //   elevation: 4,
    //   color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
    //   shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(15))),
    //   child: Padding(
    //     padding: const EdgeInsets.all(10),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: <Widget>[
    //         ClipRRect(
    //           borderRadius: const BorderRadius.all(Radius.circular(15)),
    //           child: Image.network(
    //             event.eventUrl,
    //             height: 150,
    //             fit: BoxFit.fitWidth,
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.only(top: 8.0, left: 8.0),
    //           child: Row(
    //             children: <Widget>[
    //               Expanded(
    //                 flex: 3,
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: <Widget>[
    //                     Text(
    //                       event.title,
    //                       style: TextStyle(
    //                           fontFamily: 'Montserrat',
    //                           fontSize: 17,
    //                           color: Theme.of(context).hintColor),
    //                     ),
    //                     const SizedBox(
    //                       height: 5,
    //                     ),
    //                     FittedBox(
    //                       child: Row(
    //                         children: [
    //                           Icon(
    //                             Icons.location_on,
    //                             size: 14,
    //                             color: Theme.of(context).hintColor,
    //                           ),
    //                           const SizedBox(
    //                             width: 5,
    //                           ),
    //                           Text(
    //                             event.location,
    //                             style: TextStyle(
    //                                 fontFamily: 'Montserrat',
    //                                 fontSize: 13,
    //                                 color: Theme.of(context).hintColor),
    //                           )
    //                         ],
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //               Expanded(
    //                 flex: 1,
    //                 child: Text(
    //                   event.duration.toUpperCase(),
    //                   textAlign: TextAlign.right,
    //                   style: TextStyle(
    //                       fontFamily: 'Montserrat',
    //                       fontSize: 17,
    //                       fontWeight: FontWeight.w600,
    //                       color: Theme.of(context).hintColor),
    //                 ),
    //               )
    //             ],
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        // decoration: BoxDecoration(
        //     color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Theme.of(context).shadowColor.withOpacity(0.6),
        //         spreadRadius: 1,
        //         blurRadius: 5,
        //         offset: const Offset(0, 5),
        //       )
        //     ],
        //     border: Border.all(
        //       color: Theme.of(context).shadowColor.withOpacity(0.5),
        //       width: 2,
        //     ),
        //     borderRadius: BorderRadius.circular(15)),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).hintColor.withAlpha(80)),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).focusColor.withAlpha(100),
              blurRadius: 10.0,
              spreadRadius: 0.0,
            ),
          ],
          color: Theme.of(context).focusColor.withOpacity(0.2),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12)
                  .copyWith(right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalizeAllWord(widget.event.title),
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).hintColor),
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
                          Text(
                            capitalizeAllWord(widget.event.location),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',
                                fontSize: 13,
                                color: Theme.of(context).hintColor),
                            // softWrap: true,
                          )
                        ],
                      )
                    ],
                  ),
                  widget.event.uid == user.uid
                      ? IconButton(
                          onPressed: () {
                            showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shrinkWrap: true,
                                      children: [
                                        'Delete',
                                      ]
                                          .map((e) => InkWell(
                                                onTap: () {
                                                  deletePost(
                                                      widget.event.eventId);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: Text(e),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(Icons.more_vert))
                      : Container()
                ],
              ),
            ),

            //image section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height * 0.28,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.event.eventUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            //row of loaction and date etc
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Posted By:',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).hintColor),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(widget.event.profImage),
                                radius: 15,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                capitalizeAllWord(
                                    '${widget.event.username} (${widget.event.bio})'),
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
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 14,
                            color: Theme.of(context).hintColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            DateFormat.yMMMEd().format(
                                DateTime.tryParse(widget.event.duration)!),
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13,
                                color: Theme.of(context).hintColor),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8)),
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
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ));
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
