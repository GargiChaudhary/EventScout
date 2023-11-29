import 'package:events/firebase_options.dart';
import 'package:events/providers/app_state.dart';
import 'package:events/providers/theme_provider.dart';
import 'package:events/providers/user_provider.dart';
import 'package:events/responsive/mobile_screen_layout.dart';
import 'package:events/responsive/responsive_layout.dart';
import 'package:events/responsive/web_screen_layout.dart';
import 'package:events/screens/landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDUdApdIt69ZDepo-kKyyGzF7eSqy4tZ14",
            appId: "1:1041655485643:web:04ba6b0256da49fb0bb74e",
            messagingSenderId: "1041655485643",
            storageBucket: "eventscout-3035d.appspot.com",
            projectId: "eventscout-3035d"));
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Builder(builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                      webScreenLayout: WebScreenLayout(),
                      mobileScreenLayout: MobileScreen());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }
              return const LandingScreen(); //i chnaged this in codespace let's see the change
            },
          ),
        );
      }),
    );
  }
}
//flutter run -d chrome --web-renderer html

/*** EventScout is a dynamic mobile application developed using Flutter technology and integrated with Firebase for secure user authentication. This innovative app allows users to effortlessly explore and engage with events by providing features such as creating and adding events with comprehensive details like event name, date, location, images, descriptions, and subtitles. Moreover, EventScout offers a user-friendly search functionality that enables users to discover events based on their proximity, utilizing geolocation to filter events by distance from the user's current location. This project showcases my proficiency in mobile app development, Firebase integration, and leveraging geolocation services within Flutter to deliver a seamless event exploration experience for users." ***/