import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

firebase_storage.FirebaseStorage storage =
  firebase_storage.FirebaseStorage.instance;

class EditStudent extends StatefulWidget {
  final String name;
  final String classname;
  final String number;
  final String guardian;
  final String photo;
  final String documentId;

  const EditStudent({
    Key? key,
    required this.documentId,
    required this.name,
    required this.classname,
    required this.number,
    required this.guardian,
    required this.photo,
  }) : super(key: key);

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  late String updatedImagepath;

  firebase_storage.FirebaseStorage storage =
  firebase_storage.FirebaseStorage.instance;


  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _guardianController = TextEditingController();
  final _numberController = TextEditingController();

  final CollectionReference user = FirebaseFirestore.instance.collection('user');

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _classController.text = widget.classname;
    _guardianController.text = widget.guardian;
    _numberController.text = widget.number;
    updatedImagepath = widget.photo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
        actions: [
          IconButton(
            onPressed: () {
              editStudentClicked(context);
            },
            icon: const Icon(Icons.cloud_upload),
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
                    InkWell(
                      onTap: () => editPhoto(context),
                      child: CircleAvatar(
                        backgroundImage: updatedImagepath.isNotEmpty
                            ? FileImage(File(updatedImagepath))
                            : const AssetImage('assets/default_image.png') as ImageProvider,
                        radius: 80,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
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
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _classController,
                        decoration: InputDecoration(
                          labelText: "Class",
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
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _guardianController,
                        decoration: InputDecoration(
                          labelText: "Parent",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Parent Name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _numberController,
                        decoration: InputDecoration(
                          labelText: "Mobile",
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
                    ),
                  ],
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
      updatedImagepath = image.path;
    });
  }

  Future<void> editStudentClicked(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.toUpperCase();
      final classA = _classController.text.toString().trim();
      final father = _guardianController.text;
      final number = _numberController.text.trim();

      final data = {
        'name': name,
        'class ': classA,
        'guardian': father,
        'number': number,
        'image': updatedImagepath,
      };

      user.doc(widget.documentId).update(data);

      Navigator.of(context).pop(); // Close the dialog after updating
    }
  }

  void editPhoto(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Update Photo'),
          actions: [
            Column(
              children: [
                Row(
                  children: [
                    const Text('Choose from camera'),
                    IconButton(
                      onPressed: () {
                        getImage(ImageSource.camera);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Choose from gallery'),
                    IconButton(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.image,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
