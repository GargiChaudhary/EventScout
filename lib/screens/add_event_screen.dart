import 'dart:typed_data';
import 'package:events/model/our_user.dart';
import 'package:events/providers/user_provider.dart';
import 'package:events/resources/firestore_methods.dart';
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
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _punchLineController = TextEditingController();
  final List categoryIds = [0, 1, 2, 3];
  final List galleryImages = [];
  bool _isLoading = false;

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

  void postEvent(
      String uid, String username, String profImage, String bio) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadEvent(
          _titleController.text,
          _file!,
          uid,
          _descriptionController.text,
          username,
          profImage,
          bio,
          _locationController.text,
          _durationController.text,
          _punchLineController.text,
          categoryIds,
          galleryImages);
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar("Posted new event!", context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    // print(' THE PHOTOURL IS: ${user.photoUrl} ');
    return _file == null
        ? Scaffold(
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Upload event image',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.width * 0.75,
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/select.png'))),
                ),
                const SizedBox(height: 10),
                IconButton(
                    onPressed: () => _selectImage(context),
                    icon: Icon(
                      Icons.upload,
                      color: Theme.of(context).primaryColor,
                    )),
              ],
            )),
          )
        : Scaffold(
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
                        // onPressed: () => postEvent(ourUser.uid, ourUser.username,
                        //     ourUser.photoUrl, ourUser.bio),
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
                    _isLoading
                        ? const LinearProgressIndicator()
                        : const Padding(padding: EdgeInsets.only(top: 0)),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                          // radius: 20,
                          backgroundImage: NetworkImage(
                              user.photoUrl), // it is the error causing line
                        ),

                        // CircleAvatar(
                        //   backgroundImage: NetworkImage(ourUser.photoUrl),
                        // ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * 0.75,
                          width: MediaQuery.of(context).size.width * 0.75,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: MemoryImage(_file!))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
