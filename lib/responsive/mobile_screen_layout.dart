import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:events/screens/add_event_screen.dart';
import 'package:events/screens/bookmark_screen.dart';
import 'package:events/screens/home_screen.dart';
import 'package:events/screens/profile_screen.dart';
import 'package:events/screens/search_screen.dart';
import 'package:events/utils/colors.dart';
import 'package:flutter/material.dart' hide Badge;

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _page);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int? page) {
    pageController.jumpToPage(page!);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics:
            const NeverScrollableScrollPhysics(), //you won't be able to slide through the tab pages
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          ProfileScreen(),
          SearchScreen(),
          BookmarkScreen(),
          HomePage()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddEventScreen()));
        },
        backgroundColor: primaryColor,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: _page,
        onTap: navigationTapped,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        fabLocation: BubbleBottomBarFabLocation.end, //new
        // hasNotch: true, //new
        hasInk: true, //new, gives a cute ink effect
        inkColor: Colors.black12, //optional, uses theme color if not specified
        items: const <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.red,
              ),
              title: Text(
                "Home",
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
              )),
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.search,
                color: Colors.red,
              ),
              title: Text(
                "Search",
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
              )),
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.bookmark_added_outlined,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.bookmark_added_outlined,
                color: Colors.red,
              ),
              title: Text(
                "Saved",
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
              )),
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.person,
                color: Colors.red,
              ),
              title: Text(
                "Profile",
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
              ))
        ],
      ),
    );
  }
}
