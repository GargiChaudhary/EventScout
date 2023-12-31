import 'package:events/model/our_user.dart';
import 'package:events/providers/user_provider.dart';
import 'package:events/resources/firestore_methods.dart';
import 'package:events/screens/map_screen.dart';
import 'package:events/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
  final TextEditingController _ticketController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();
  List<int> categoryIds = [];
  double? latitude;
  double? longitude;
  List<String> galleryImages = [];
  bool _isLoading = false;
  final ImagePicker picker = ImagePicker();
  String eventId = const Uuid().v1();

  Future getImages() async {
    final pickedFiles = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    if (pickedFiles.isNotEmpty) {
      for (var i = 0; i < pickedFiles.length; i++) {
        final pickedFile = pickedFiles[i];
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('events/$eventId/image$i.jpg');
        await storageRef.putData(imageBytes);
        final imageUrl = await storageRef.getDownloadURL();
        setState(() {
          galleryImages.add(imageUrl);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing is selected')),
      );
    }
  }

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
          eventId,
          latitude!,
          longitude!,
          double.parse(_ticketController.text),
          _upiController.text,
          categoryIds,
          galleryImages);
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar("Posted new event!", context);
        Navigator.pop(context);
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
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).hintColor,
            )),
        actions: [
          TextButton(
            onPressed: () =>
                postEvent(user.uid, user.username, user.photoUrl, user.bio),
            child: Text(
              'Done',
              style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat'),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0)),
                  Row(
                    children: [
                      _file != null
                          ? Container(
                              height: MediaQuery.of(context).size.width * 0.25,
                              width: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: MemoryImage(_file!))),
                            )
                          : GestureDetector(
                              onTap: () {
                                _selectImage(context);
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.width * 0.25,
                                width: MediaQuery.of(context).size.width * 0.25,
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            'assets/images/select.png'))),
                              ),
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).focusColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            children: [
                              TextField(
                                controller: _titleController,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Theme.of(context).hintColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: "Event title",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                  contentPadding: const EdgeInsets.all(8),
                                ),
                              ),
                              TextField(
                                controller: _punchLineController,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Theme.of(context).hintColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: "Event subtitle",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13),
                                  contentPadding: const EdgeInsets.all(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).hintColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).focusColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 6,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Theme.of(context).hintColor,
                            fontSize: 13),
                        decoration: InputDecoration(
                          hintText: "Event description",
                          hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Theme.of(context).hintColor,
                              fontSize: 13),
                          contentPadding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).hintColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).focusColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                            controller: _durationController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              hintText: "Date",
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w600,
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
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      setState(() {
                                        _durationController.text =
                                            formattedDate; //
                                      });
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          DropdownMenu<int>(
                              width: MediaQuery.of(context).size.width * 0.85,
                              label: Text(
                                'Select category',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Theme.of(context).hintColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                              onSelected: (int? newValue) {
                                setState(() {
                                  categoryId = newValue ?? 0;
                                  if (categoryId != null) {
                                    categoryIds.clear();
                                    categoryIds.add(categoryId!);
                                    categoryIds.add(0);
                                  }
                                });
                                // List<int> genreIds;
                                // genreIds = jsonMap["genre_ids"].cast<int>();
                              },
                              inputDecorationTheme: const InputDecorationTheme(
                                  contentPadding: EdgeInsets.all(8)),
                              dropdownMenuEntries: const <DropdownMenuEntry<
                                  int>>[
                                DropdownMenuEntry(value: 1, label: 'Music'),
                                DropdownMenuEntry(value: 2, label: 'Festival'),
                                DropdownMenuEntry(value: 3, label: 'Education'),
                                DropdownMenuEntry(value: 4, label: 'Political'),
                                DropdownMenuEntry(value: 5, label: 'Sports'),
                                DropdownMenuEntry(value: 6, label: 'Meetup'),
                                DropdownMenuEntry(value: 7, label: 'Birthday'),
                                DropdownMenuEntry(value: 8, label: 'Others'),
                              ]),
                          TextField(
                            controller: _locationController,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Select Location',
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                              contentPadding: const EdgeInsets.all(8),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.location_on),
                                onPressed: () async {
                                  // Navigate to the location selection page and wait for result
                                  var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MapScreen()),
                                  );
                                  if (result != null) {
                                    setState(() {
                                      // Update the TextField with the selected address
                                      _locationController.text =
                                          result['address'];
                                      latitude = result['latitude'];
                                      longitude = result['longitude'];
                                      // Assuming 'address' is the key for the address
                                    });
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).hintColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).focusColor,
                    ),
                    child: galleryImages.isEmpty
                        ? Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  // elevation: 5,
                                  backgroundColor:
                                      Theme.of(context).primaryColor),
                              child: Text(
                                'Select images',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Theme.of(context).hintColor,
                                    fontSize: 13),
                              ),
                              onPressed: () {
                                getImages();
                              },
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(4),
                            scrollDirection: Axis.horizontal,
                            itemCount: galleryImages.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Center(
                                  child: kIsWeb
                                      ? SizedBox(
                                          width: 180,
                                          height: 180,
                                          child: Image.network(
                                              galleryImages[index]),
                                        )
                                      : SizedBox(
                                          height: 180,
                                          width: 180,
                                          child: Image.network(
                                              galleryImages[index])));
                            },
                          ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).hintColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).focusColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _ticketController,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "Ticket Price",
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                              contentPadding: const EdgeInsets.all(8),
                            ),
                          ),
                          TextField(
                            controller: _upiController,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                            decoration: InputDecoration(
                              hintText: "UPI ID: example@ybl",
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                              contentPadding: const EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
