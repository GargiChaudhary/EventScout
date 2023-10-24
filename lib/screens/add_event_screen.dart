import 'dart:typed_data';

import 'package:events/model/our_user.dart';
import 'package:events/providers/user_provider.dart';
import 'package:events/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  Uint8List? _file;
  final TextEditingController _titleController = TextEditingController();
  // bool _isLoading = false;

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Select Event Picture:'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void postEvent(String uid, String username, String profImage) async {
    try {} catch (e) {}
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final OurUser ourUser = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 5,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Add your event!!!",
          style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat'),
        ),
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).hintColor,
            )),
        actions: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.check,
                    color: Theme.of(context).hintColor,
                  )),
              Text(
                'Post',
                style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat'),
              )
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        ourUser.photoUrl), // it is the error causing line
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Stack(children: [
                    Visibility(
                      visible: _file != null,
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.75,
                        width: MediaQuery.of(context).size.width * 0.75,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    'https://www.euroschoolindia.com/blogs/wp-content/webp-express/webp-images/uploads/2023/08/cartoons-for-kids.jpg.webp'))),
                      ),
                    ),
                    Visibility(
                      visible: _file == null,
                      child: GestureDetector(
                        onTap: () => _selectImage(context),
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.75,
                          width: MediaQuery.of(context).size.width * 0.75,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              image: const DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      AssetImage('assets/images/select.png'))),
                        ),
                      ),
                    )
                  ])
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
