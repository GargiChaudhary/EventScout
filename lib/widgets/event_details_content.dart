import 'package:events/model/guest.dart';
import 'package:events/utils/colors.dart';
import 'package:events/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/event.dart';

class EventDetailsContent extends StatelessWidget {
  const EventDetailsContent({super.key});

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

  @override
  Widget build(BuildContext context) {
    // DateTime eventDate = DateFormat('yyyy-MM-dd').parse(widget.event.duration);
    final event = Provider.of<Event>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    DateTime eventDate = DateFormat('yyyy-MM-dd').parse(event.duration);
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
            height: 10,
          ),
          Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.30),
              child: FittedBox(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 17,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      event.address,
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
            padding: const EdgeInsets.only(left: 8.0),
            child: ElevatedButton(
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
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 16,
                  color: Theme.of(context).hintColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  DateFormat.yMMMEd()
                      .format(DateTime.tryParse(event.duration)!),
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Theme.of(context).hintColor),
                )
              ],
            ),
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
          ),
          if (event.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                for (final galleryImagePath in event.galleryImages)
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        galleryImagePath,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "POSTED BY",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(event.profImage),
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
                          capitalizeAllWord(event.username),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat',
                              color: Theme.of(context).hintColor,
                              fontSize: 15),
                        ),
                        Text(
                          event.bio,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11,
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 5),
            child: Text(
              DateFormat.yMMMd().format(event.datePublished.toDate()),
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
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
