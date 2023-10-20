import 'package:events/resources/auth_methods.dart';
import 'package:events/responsive/mobile_screen_layout.dart';
import 'package:events/screens/signup_screen.dart';
import 'package:events/utils/utils.dart';
import 'package:events/widgets/text_field_input.dart';
import 'package:flutter/material.dart';

import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreen())));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
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
                    Text(
                      "Hello Again!",
                      style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).primaryColor,
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
                    InkWell(
                      onTap: loginUser,
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 60),
                              padding: const EdgeInsets.all(15),
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                                color: Color.fromARGB(167, 255, 119, 65),
                              ),
                              child: const Text(
                                "Log in",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Not a member?",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11,
                              color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignupScreen()));
                          },
                          child: const Text(
                            "Register now",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 0, 106, 192)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
