import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/resources/auth_methods.dart';
import 'package:events/utils/colors.dart';
import 'package:events/utils/utils.dart';
import 'package:events/widgets/profile_bg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int eventLen = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      //get posts length
      var eventSnap = await FirebaseFirestore.instance
          .collection('events')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      eventLen = eventSnap.docs.length;
      userData = userSnap.data()!;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Stack(
              children: [
                ProfilePageBackground(
                  imageUrl: userData['photoUrl'],
                  screenHeight: MediaQuery.of(context).size.height,
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        Center(
                          child: CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 58,
                            child: CircleAvatar(
                              radius: 55,
                              backgroundImage:
                                  NetworkImage(userData['photoUrl']),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                            onPressed: () => AuthMethods().signOut(),
                            child: const Text("Sign out")),
                        Container(
                          color: Theme.of(context).primaryColor,
                          width: 300,
                          height: 300,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white10.withAlpha(80)),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withAlpha(100),
                                  blurRadius: 10.0,
                                  spreadRadius: 0.0,
                                ),
                              ],
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: Center(
                              child: Text("Hello"),
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
