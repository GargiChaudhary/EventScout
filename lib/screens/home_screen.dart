import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/providers/app_state.dart';
import 'package:events/model/event.dart';
import 'package:events/screens/event_details_page.dart';
import 'package:events/utils/global_variables.dart';
import 'package:events/widgets/change_theme_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/category.dart';
import '../widgets/category_widget.dart';
import '../widgets/event_widget.dart';
import '../widgets/home_page_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          HomePageBackground(
            screenHeight: MediaQuery.of(context).size.height,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Row(
                      children: [
                        Text(
                          "EventsScout",
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontFamily: 'Montserrat',
                              fontSize: 16),
                        ),
                        const Spacer(),
                        const ChangeThemeButtonWidget()
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(capitalizeAllWord("What's Up Gargi!"),
                        style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 30)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final category in categories)
                            CategoryWidget(category: category)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Consumer<AppState>(
                      builder: (context, appState, _) => StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('events')
                            .orderBy('datePublished', descending: true)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                          final selectedCategoryId =
                              appState.selectedCategoryId;
                          final events = snapshot.data!.docs
                              .map((eventDoc) => Event.fromSnap(eventDoc))
                              .where((event) => event.categoryIds
                                  .contains(selectedCategoryId))
                              .toList();
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: events.length,
                            itemBuilder: (ctx, index) => Container(
                              margin: EdgeInsets.symmetric(
                                horizontal:
                                    width > webScreenSize ? width * 0.3 : 0,
                                vertical: width > webScreenSize ? 15 : 5,
                              ),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EventDetailsPage(
                                                    event: events[index])));
                                  },
                                  child: EventWidget(event: events[index])),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
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
