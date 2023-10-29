import 'package:events/model/guest.dart';
import 'package:events/utils/colors.dart';
import 'package:events/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/event.dart';

class EventDetailsContent extends StatelessWidget {
  const EventDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final event = Provider.of<Event>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: color1,
              )),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.30),
            child: Text(
              event.title,
              style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 30,
                  color: color1,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.30),
              child: FittedBox(
                child: Row(
                  children: [
                    const Text(
                      "-",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          color: color1,
                          fontWeight: FontWeight.w600),
                    ),
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      event.location,
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          color: color1,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              )),
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "GUESTS",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final guest in guests)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ClipOval(
                      child: Image.asset(
                        guest.imagePath,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              event.punchLine,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  color: Palette.myPink.shade900,
                  fontWeight: FontWeight.w600),
            ),
            // child: RichText(
            //   text: TextSpan(children: [
            //     TextSpan(
            //       text: '${event.punchLine1} ',
            //       style: TextStyle(
            //           fontFamily: 'Montserrat',
            //           fontSize: 20,
            //           color: Palette.myPink.shade900,
            //           fontWeight: FontWeight.w600),
            //     ),
            //     TextSpan(
            //       text: event.punchLine2,
            //       style: TextStyle(
            //           fontFamily: 'Montserrat',
            //           fontSize: 20,
            //           color: Theme.of(context).hintColor,
            //           fontWeight: FontWeight.w600),
            //     ),
            //   ]),
            // ),
          ),
          if (event.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                event.description,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          if (event.galleryImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
              child: Text(
                "GALLERY",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: <Widget>[
          //       for (final galleryImagePath in event.galleryImages)
          //         Container(
          //           margin:
          //               const EdgeInsets.only(left: 16, right: 16, bottom: 32),
          //           child: ClipRRect(
          //             borderRadius: const BorderRadius.all(Radius.circular(20)),
          //             child: Image.asset(
          //               galleryImagePath,
          //               width: 180,
          //               height: 180,
          //               fit: BoxFit.cover,
          //             ),
          //           ),
          //         )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
