import 'dart:typed_data';
import 'package:events/model/our_user.dart';
import 'package:events/providers/user_provider.dart';
import 'package:events/resources/firestore_methods.dart';
import 'package:events/utils/utils.dart';
import 'package:events/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

const List<String> list = <String>['Music', 'Education', 'Political', 'Sports'];

class _AddEventScreenState extends State<AddEventScreen> {
  Uint8List? _file;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _punchLineController = TextEditingController();
  final List categoryIds = [0];
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
    int? categoryId;
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
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectImage(context),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        image: const DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/images/select.png'))),
                  ),
                ),
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
                          radius: 20,
                          backgroundImage: NetworkImage(
                              user.photoUrl), // it is the error causing line
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * 0.7,
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: MemoryImage(_file!))),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldInput(
                        textEditingController: _titleController,
                        hintText: "Event Title",
                        textInputType: TextInputType.text),
                    TextFieldInput(
                        textEditingController: _punchLineController,
                        hintText: "Event Subtitle",
                        textInputType: TextInputType.text),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 6),
                      child: DropdownMenu<int>(
                          width: MediaQuery.of(context).size.width * 0.8,
                          label: Text(
                            'Event type',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).hintColor,
                                fontSize: 13),
                          ),
                          onSelected: (int? newValue) {
                            setState(() {
                              categoryId = newValue ??
                                  0; // Use null-aware operator to handle null case
                              if (categoryId != null) {
                                categoryIds.add(categoryId);
                              }
                            });
                          },
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: Theme.of(context).primaryColor,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5.0),
                          ),
                          dropdownMenuEntries: const <DropdownMenuEntry<int>>[
                            DropdownMenuEntry(value: 1, label: 'Music'),
                            DropdownMenuEntry(value: 2, label: 'Sports'),
                            DropdownMenuEntry(value: 3, label: 'Education'),
                            DropdownMenuEntry(value: 4, label: 'Political'),
                            DropdownMenuEntry(value: 5, label: 'Others'),
                          ]),
                    ),

                    // DropdownMenu<int>(

                    // value: categoryId,
                    // icon: const Icon(Icons.arrow_downward),
                    // iconSize: 24,
                    // elevation: 16,
                    // style: TextStyle(
                    //   color: Theme.of(context).hintColor,
                    // ),
                    // underline: Container(
                    //   height: 2,
                    //   color: Theme.of(context).primaryColor,
                    // ),

                    //     onChanged: (int? newValue) {
                    //       setState(() {
                    //         categoryId = newValue ??
                    //             0; // Use null-aware operator to handle null case
                    //         if (categoryId != null) {
                    //           categoryIds.add(categoryId);
                    //         }
                    //       });
                    //     },
                    //     dropdownMenuEntries: const <DropdownMenuItem<int>>[
                    //       DropdownMenuItem<int>(
                    //         value: 1,
                    //         child: Text('Music'),
                    //       ),
                    //       DropdownMenuItem<int>(
                    //         value: 2,
                    //         child: Text('Sports'),
                    //       ),
                    //       DropdownMenuItem<int>(
                    //         value: 3,
                    //         child: Text('Education'),
                    //       ),
                    //       DropdownMenuItem<int>(
                    //         value: 4,
                    //         child: Text('Political'),
                    //       ),
                    //       DropdownMenuItem<int>(
                    //         value: 5,
                    //         child: Text('Others'),
                    //       ),
                    //     ],
                    //   ),

                    TextFieldInput(
                        textEditingController: _locationController,
                        hintText: "Event location",
                        textInputType: TextInputType.text),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 6),
                      child: TextField(
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Theme.of(context).hintColor,
                            fontSize: 13),
                        controller: _durationController,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).primaryColor,
                          filled: true,
                          hintText: "Event date",
                          hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Theme.of(context).hintColor,
                              fontSize: 13),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today,
                              size: 20,
                            ),
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2023),
                                lastDate: DateTime(2101),
                              ).then((pickedDate) {
                                if (pickedDate != null) {
                                  setState(() {
                                    _durationController.text =
                                        pickedDate.toString();
                                  });
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    TextFieldInput(
                        textEditingController: _descriptionController,
                        hintText: "Event Description...",
                        maxLines: 8,
                        textInputType: TextInputType.text),
                  ],
                ),
              ),
            ),
          );
  }
}
