import 'dart:typed_data';

import 'package:events/resources/auth_methods.dart';
import 'package:events/responsive/mobile_screen_layout.dart';
import 'package:events/responsive/responsive_layout.dart';
import 'package:events/responsive/web_screen_layout.dart';
import 'package:events/screens/login_screen.dart';
import 'package:events/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    setState(() {
      _isLoading = false;
    });
    if (res != "success") {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreen())));
    }
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
                      height: 30,
                    ),
                    Text(
                      "Ready to explore?",
                      style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).primaryColor,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "Let's go!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    'https://www.asiamediajournal.com/wp-content/uploads/2022/11/Default-PFP.jpg'),
                              ),
                        Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                                onPressed: selectImage,
                                icon: const Icon(Icons.add_a_photo)))
                      ],
                    ),
                    TextFieldInput(
                        textEditingController: _usernameController,
                        hintText: "Enter username",
                        textInputType: TextInputType.text),
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
                    TextFieldInput(
                        textEditingController: _bioController,
                        hintText: "Enter bio",
                        textInputType: TextInputType.text),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: signUpUser,
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              padding: const EdgeInsets.all(15),
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                                color: Color.fromARGB(167, 255, 119, 65),
                              ),
                              child: const Text(
                                "Register",
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
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11,
                              color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                          },
                          child: const Text(
                            "Log in",
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
