import 'package:events/widgets/home_page_background.dart';
import 'package:flutter/material.dart';

class SearchByDistance extends StatefulWidget {
  const SearchByDistance({super.key});

  @override
  State<SearchByDistance> createState() => _SearchByDistanceState();
}

class _SearchByDistanceState extends State<SearchByDistance> {
  double maxDistance = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HomePageBackground(
            screenHeight: MediaQuery.of(context).size.height,
          ),
          Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Search events within ",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).focusColor)),
                    child: Text(
                      "10 km",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor),
                    ),
                    onPressed: () {
                      setState(() {
                        maxDistance = 10;
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).focusColor)),
                    child: Text(
                      "50 km",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor),
                    ),
                    onPressed: () {
                      setState(() {
                        maxDistance = 50;
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).focusColor)),
                    child: Text(
                      "70 km",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor),
                    ),
                    onPressed: () {
                      setState(() {
                        maxDistance = 70;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).focusColor)),
                    child: Text(
                      "100 km",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor),
                    ),
                    onPressed: () {
                      setState(() {
                        maxDistance = 100;
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).focusColor)),
                    child: Text(
                      "200 km",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor),
                    ),
                    onPressed: () {
                      setState(() {
                        maxDistance = 200;
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).focusColor)),
                    child: Text(
                      "300 km",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor),
                    ),
                    onPressed: () {
                      setState(() {
                        maxDistance = 300;
                      });
                    },
                  ),
                ],
              ),
              // 10 , 50 , 70
              // 100, 200, 300,
              // 500 , all
            ],
          )
        ],
      ),
    );
  }
}

// tum thakte nhi ho kya, poore din mere dimg m chlte chlte
// jheel ko eng m khte h lake, why should i look for someone lese when u r laakhon m ek
// tum amazon p listed ho ky, soch rhi hu prime membership lelu one day delivery hojati
//tum shampoo ho kya, 
// are you siri, becuase you autocomplete me
// apke hth bde bhaari lgre h, lao aapke liye m pkd leti hu
//I think I saw you on Spotify, you were listed as the hottest single.