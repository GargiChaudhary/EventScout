import 'package:events/widgets/save_pdf_button.dart';
import 'package:flutter/material.dart';

class Ticket extends StatefulWidget {
  final String image;
  final String eventName;
  final String eventLoc;
  final String eventDate;
  final String eventTime;
  final String appName;
  final String price;
  const Ticket(
      {super.key,
      required this.image,
      required this.eventName,
      required this.eventLoc,
      required this.eventDate,
      required this.eventTime,
      required this.appName,
      required this.price});

  @override
  State<Ticket> createState() => _TicketState();
}

// event image
// event name
// event location
// event date, event time
// appName, price

class _TicketState extends State<Ticket> {
  @override
  void initState() {
    print("Event image: ${widget.image}");
    print("Event name: ${widget.eventName}");
    print("Event location: ${widget.eventLoc}");
    print("Event date: ${widget.eventDate}");
    print("Event time: ${widget.eventTime}");
    print("App name: ${widget.appName}");
    print("Price: ${widget.price}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 5),
              )
            ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                ClipRRect(
                    // borderRadius: BorderRadius.circular(15.0),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      widget.image,
                      height: MediaQuery.of(context).size.width > 600
                          ? MediaQuery.of(context).size.width * 0.3
                          : MediaQuery.of(context).size.width * 0.7,
                      // height: MediaQuery.of(context).size.width * 0.7,
                      width: MediaQuery.of(context).size.width * 0.7,
                      fit: BoxFit.cover,
                    )),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Rally",
                  style: TextStyle(
                      fontFamily: '',
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                    ),
                    Text(
                      "Dayal Bagh, Agra",
                      style: TextStyle(
                        fontFamily: '',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                  style: TextStyle(fontSize: 25, color: Colors.grey),
                  softWrap: false,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "01/12/2023",
                        style: TextStyle(
                            fontFamily: '',
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "08:00 AM",
                        style: TextStyle(
                            fontFamily: '',
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(
                          fontFamily: '',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Time",
                        style: TextStyle(
                          fontFamily: '',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
                  style: TextStyle(fontSize: 25, color: Colors.grey),
                  softWrap: false,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "PhonePay",
                        style: TextStyle(
                            fontFamily: '',
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Rs. 400",
                        style: TextStyle(
                            fontFamily: '',
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Payment Method",
                        style: TextStyle(
                          fontFamily: '',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Price",
                        style: TextStyle(
                          fontFamily: '',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Thanks for choosing EventScout!",
            style: TextStyle(color: Colors.grey, fontSize: 12.00),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            "Contact 80774 XXXXX for any clarifications.",
            style: TextStyle(color: Colors.grey, fontSize: 12.00),
          ),
          const SizedBox(
            height: 15,
          ),
          SavePdfButton(
            image: widget.image,
          ),
        ],
      ),
    ));
  }
}
