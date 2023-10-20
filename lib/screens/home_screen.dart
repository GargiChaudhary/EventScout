import 'package:events/app_state.dart';
import 'package:events/model/event.dart';
import 'package:events/style_guide.dart';
import 'package:events/screens/event_details_page.dart';
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
      primaryColor: const Color(0xFFFF4700),
      useMaterial3: true,
      colorScheme: const ColorScheme.light());
  final ThemeData _darkTheme = ThemeData(
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: const Color.fromRGBO(35, 35, 35, 1),
      primaryColor: const Color(0xFFFF4700),
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
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      home: Scaffold(
        body: ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          child: Stack(
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
                              "LOCAL EVENTS",
                              style: fadedTextStyle,
                            ),
                            const Spacer(),
                            // GestureDetector(
                            //   onTap: () => ChangeThemeButtonWidget(),
                            //   child: const Icon(
                            //     Icons.person_outline,
                            //     color: Color(0x99FFFFFF),
                            //     size: 30,
                            //   ),
                            // )
                            ChangeThemeButtonWidget(
                              onThemeToggle: toggleTheme,
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          "What's Up",
                          style: whiteHeadingTextStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Consumer<AppState>(
                          builder: (context, appState, _) =>
                              SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (final category in categories)
                                  CategoryWidget(category: category)
                              ],
                            ),
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
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EventDetailsPage(
                                                    event: event)));
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
      ),
    );
  }
}
