import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/model/event.dart';
import 'package:events/providers/app_state.dart';
import 'package:events/screens/event_details_page.dart';
import 'package:events/utils/global_variables.dart';
import 'package:events/widgets/event_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Consumer<AppState>(
        builder: (context, appState, _) => StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('events')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              // Handle the error or the case when there's no data
              return Center(
                child: Text(snapshot.hasError
                    ? 'Error: ${snapshot.error}'
                    : 'No data available'),
              );
            }
            final selectedCategoryId = appState.selectedCategoryId;
            final events = snapshot.data!.docs
                .map((eventDoc) => Event.fromSnap(eventDoc))
                .where(
                    (event) => event.categoryIds.contains(selectedCategoryId))
                .toList();
            return ListView.builder(
              shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (ctx, index) => Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width > webScreenSize ? width * 0.3 : 0,
                  vertical: width > webScreenSize ? 15 : 5,
                ),
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              EventDetailsPage(event: events[index])));
                    },
                    child: EventWidget(event: events[index])),
              ),
            );
          },
        ),
      ),
    );
  }
}
