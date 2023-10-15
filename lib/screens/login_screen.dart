import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1502635385003-ee1e6a1a742d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80"),
                    fit: BoxFit.cover)),
          ),
        ),
        const Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "Hello Again!",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                "Welcome back you've",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: "Montserrat",
                ),
              ),
              Text(
                "been missed!",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: "Montserrat",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField()
            ],
          ),
        )
      ],
    ));
  }
}
