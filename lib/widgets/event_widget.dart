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
        // color: mobileBackgroundColor,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.6),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 5),
              )
            ],
            border: Border.all(
              color: Theme.of(context).shadowColor.withOpacity(0.5),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                  .copyWith(right: 0),
              child: Row(
                children: [
                  //header section
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.event.profImage),
                      radius: 20,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capitalizeAllWord(widget.event.username),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',
                                fontSize: 15),
                          ),
                          Text(
                            widget.event.bio,
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 11,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: Image.network(
                widget.event.eventUrl,
                fit: BoxFit.cover,
              ),
            ),

            //description and number of comments
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: const TextStyle(fontFamily: 'Montserrat'),
                    child: Text(
                      'some likes and some comments',
                      // style: Theme.of(context).textTheme.bodyText2,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Theme.of(context).hintColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 8),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          children: [
                            TextSpan(
                                text: capitalizeAllWord("username"),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor)),
                            TextSpan(
                                text: 'some description',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: Theme.of(context).hintColor,
                                    fontWeight: FontWeight.w300))
                          ]),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.event.datePublished.toDate()),
                      style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).hintColor,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
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
