import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final CollectionReference user =
      FirebaseFirestore.instance.collection('user');

  File? imageFile;
  String? imagePath; // Added imagePath variable to store image path

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _guardianController = TextEditingController();
  final _mobileController = TextEditingController();

  Future<void> imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        imagePath = pickedFile.path; // Update imagePath with picked file path
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        imagePath = pickedFile.path; // Update imagePath with picked file path
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadFile() async {
    if (imageFile == null) return;
    final fileName = imageFile!.path.split('/').last;
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
      await ref.putFile(imageFile!);
    } catch (e) {
      print('error occurred: $e'); // Corrected print statement
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('Add Student'),
        actions: [
          IconButton(
            onPressed: () {
              addDonor(context);
            },
            icon: const Icon(Icons.save_alt_outlined),
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: imageFile != null
                          ? FileImage(imageFile!)
                          : AssetImage('images/sd1.png') as ImageProvider,
                      radius: 99,
                    ),
                    Positioned(
                      bottom: 20,
                      right: 5,
                      child: IconButton(
                        onPressed: () {
                          addPhoto(context);
                        },
                        icon: const Icon(Icons.camera_alt),
                        color: Colors.white,
                        iconSize: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: 'Enter name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _classController,
                  decoration: InputDecoration(
                    labelText: "Class",
                    hintText: 'Enter class',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Class';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _guardianController,
                  decoration: InputDecoration(
                    labelText: "Guardian",
                    hintText: 'Enter Guardian name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Guardian';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _mobileController,
                  decoration: InputDecoration(
                    labelText: "Mobile",
                    hintText: 'Mobile Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Mobile';
                    } else if (value.length != 10) {
                      return 'Mobile number should be 10 digits';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      return;
    }
    setState(() {
      imageFile = File(image.path);
      imagePath = image.path;
    });
  }

  void addPhoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Profile'),
          actions: [
            IconButton(
              onPressed: () {
                imgFromCamera(); // Use imgFromCamera to set image
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: () {
                imgFromGallery(); // Use imgFromGallery to set image
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.image,
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  void addDonor(BuildContext ctx) {
    if (_formKey.currentState!.validate() && imageFile != null) {
      final data = {
        'name': _nameController.text.trim(),
        'class': _classController.text.trim(),
        'guardian': _guardianController.text.trim(),
        'number': _mobileController.text.trim(),
        'image': imagePath,
      };
      user.add(data);

      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text("Successfully added"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        imageFile = null;
        imagePath = null; // Reset imagePath after adding data
        _nameController.clear();
        _classController.clear();
        _guardianController.clear();
        _mobileController.clear();
      });
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Add Profile Picture '),
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(10),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
