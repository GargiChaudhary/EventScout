import 'package:events/resources/auth_methods.dart';
import 'package:events/utils/colors.dart';
import 'package:events/widgets/profile_bg.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ProfilePageBackground(
            imageUrl:
                'https://i.pinimg.com/236x/dd/97/3a/dd973ac116a977c8dd5296b0da504b8c.jpg',
            screenHeight: MediaQuery.of(context).size.height,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const Center(
                    child: CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 58,
                      child: CircleAvatar(
                          radius: 55,
                          backgroundImage: NetworkImage(
                              'https://i.pinimg.com/236x/dd/97/3a/dd973ac116a977c8dd5296b0da504b8c.jpg')),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () => AuthMethods().signOut(),
                      child: const Text("Sign out"))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
