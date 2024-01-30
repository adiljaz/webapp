import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// Removed unused imports

// Initialized Firebase storage
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

  // Removed unnecessary variables

    final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _guardianController = TextEditingController();
  final _mobileController = TextEditingController();

  // Function to pick image from gallery
  Future imgFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        // Removed unnecessary uploadFile call
      } else {
        print('No image selected.');
      }
    });
  }

  // Function to pick image from camera
  Future imgFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        // Removed unnecessary uploadFile call
      } else {
        print('No image selected.');
      }
    });
  }

  // Removed unnecessary uploadFile function

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
                      // Updated to show image from imageFile or default image
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
                // TextFormField widgets remain unchanged
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Removed getImage function as it's redundant

  void addPhoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog( 
          content: const Text('Profile'),
          actions: [
            IconButton(
              onPressed: () {
                imgFromCamera(); // Changed to call imgFromCamera
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: () {
                imgFromGallery(); // Changed to call imgFromGallery
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
        'image': imageFile!.path, // Changed to use path directly
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
