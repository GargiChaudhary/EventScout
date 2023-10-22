import 'package:events/providers/app_state.dart';
import 'package:events/model/event.dart';
import 'package:events/screens/event_details_page.dart';
import 'package:events/utils/colors.dart';
import 'package:events/utils/palette.dart';
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
  final ThemeData _lightTheme = ThemeData(
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      primaryColor: const Color(0xfff6a192),
      primarySwatch: Palette.myPink,
      useMaterial3: true,
      colorScheme: const ColorScheme.light());
  final ThemeData _darkTheme = ThemeData(
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: const Color.fromRGBO(35, 35, 35, 1),
      primaryColor: const Color(0xfff6a192),
      primarySwatch: Palette.myPink,
      useMaterial3: true,
      colorScheme: const ColorScheme.dark());
  bool _isDarkMode = false;

  void toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      home: Scaffold(
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
                          const Text(
                            "EventsScout",
                            style: TextStyle(
                                color: darkcolor4,
                                fontFamily: 'Montserrat',
                                fontSize: 16),
                          ),
                          const Spacer(),
                          ChangeThemeButtonWidget(
                            onThemeToggle: toggleTheme,
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text("What's Up Gargi!",
                          style: TextStyle(
                              color: blackColor,
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
                        builder: (context, appState, _) => Column(
                          children: <Widget>[
                            for (final event in events.where((e) => e
                                .categoryIds
                                .contains(appState.selectedCategoryId)))
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          EventDetailsPage(event: event)));
                                },
                                child: EventWidget(event: event),
                              )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
