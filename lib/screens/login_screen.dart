import 'package:events/widgets/text_field_input.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

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
        Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Hello Again!",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                "Welcome back you've",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: "Montserrat",
                ),
              ),
              const Text(
                "been missed!",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: "Montserrat",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Enter email",
                  textInputType: TextInputType.emailAddress),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: "Password",
                textInputType: TextInputType.text,
                isPswd: true,
              ),
              Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
                padding: const EdgeInsets.all(15),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  color: Color.fromARGB(167, 255, 119, 65),
                ),
                child: const Text("Log in"),
              ),
              Row(
                children: [
                  const Text(
                    "Not a member?",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 11,
                        color: Colors.black),
                  ),
                  GestureDetector(
                    child: const Text(
                      "Register now",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 11,
                          color: Colors.blue),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    ));
  }
}
