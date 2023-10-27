import 'package:flutter/material.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form-Like Structure'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 300,
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Theme.of(context).hintColor,
                        fontSize: 13),
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).primaryColor,
                      hintText: "Enter title",
                      hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Theme.of(context).hintColor,
                          fontSize: 13),
                      filled: true,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                  ),
                  TextField(
                    controller: emailController,
                    maxLines: 6,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Theme.of(context).hintColor,
                        fontSize: 13),
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).primaryColor,
                      hintText: "Type description",
                      hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Theme.of(context).hintColor,
                          fontSize: 13),
                      filled: true,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
