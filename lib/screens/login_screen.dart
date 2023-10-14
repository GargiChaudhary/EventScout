import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Stack(
      //   children: [
      //     HomePageBackground(
      //       screenHeight: MediaQuery.of(context).size.height,
      //     )
      //   ],
      // ),
      // body: Stack(children: [
      //   Opacity(
      //     opacity: 0.5,
      //     child: Container(
      //       decoration: const BoxDecoration(
      //           image: DecorationImage(
      //               image: NetworkImage(
      //                   "https://images.unsplash.com/photo-1502635385003-ee1e6a1a742d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80"),
      //               fit: BoxFit.cover)),
      //     ),
      //   ),
      //   Column(
      //     children: [
      //       Image.asset(
      //         'assets/images/explorerbg.png',
      //         height: 300,
      //         width: 200,
      //       ),
      //       Text(
      //         "Hello there",
      //         style: TextStyle(fontSize: 30, color: Colors.black),
      //       )
      //     ],
      //   )
      // ]),
      body: Text(
        "Hello",
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
