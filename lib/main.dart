import 'package:events/screens/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        primaryColor: const Color(0xFFFF4700),
        useMaterial3: true,
      ),
      home: const LandingScreen(),
    );
  }
}
