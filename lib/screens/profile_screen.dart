import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/model/event.dart';
import 'package:events/resources/auth_methods.dart';
import 'package:events/screens/event_details_page.dart';
import 'package:events/screens/home_screen.dart';
import 'package:events/utils/colors.dart';
import 'package:events/utils/palette.dart';
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            FirebaseAuth.instance.currentUser!.uid == widget.uid
                                ? IconButton(
                                    onPressed: () => AuthMethods().signOut(),
                                    icon: const Icon(
                                      Icons.logout_rounded,
                                      color: Colors.white,
                                    ),
                                  )
                                : const SizedBox(
                                    width: 5,
                                  ),
                          ],
                        ),
                        Text(
                          capitalizeAllWord(userData['username']),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 22,
                              color: Palette.myPink.shade900,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          capitalizeAllWord(userData['bio']),
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
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
                        // const Divider(),
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('events')
                                .where('uid', isEqualTo: widget.uid)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return GridView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    (snapshot.data! as dynamic).docs.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  DocumentSnapshot snap =
                                      (snapshot.data! as dynamic).docs[index];

                                  return InkWell(
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EventDetailsPage(
                                                    event: Event.fromSnap(
                                                        snapshot.data!
                                                            .docs[index])))),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        child: Image(
                                          image: NetworkImage(snap['eventUrl']),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
