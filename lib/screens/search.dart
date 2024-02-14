import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:h1/screens/edit.dart';
import 'package:h1/screens/studentdetails.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final CollectionReference user =
      FirebaseFirestore.instance.collection('user');

  List<DocumentSnapshot> findUsers = [];

  void _runFilter(String enteredKeyword) async {
    final QuerySnapshot result = await user.get();
    final List<DocumentSnapshot> documents = result.docs;
    List<DocumentSnapshot> resultDocuments = [];

    if (enteredKeyword.isEmpty) {
      setState(() {
        findUsers = documents;
      });
    } else {
      documents.forEach((DocumentSnapshot document) {
        if (document
            .data()!
            .toString()
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase())) {
          resultDocuments.add(document);
        }
      });

      setState(() {
        findUsers = resultDocuments;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  onChanged: (value) => _runFilter(value),
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: findUsers.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot document = findUsers[index];
                    final Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return Card(
                      color: const Color.fromARGB(255, 160, 207, 246),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: data['image'] != null
                              ? FileImage(File(data['image']))
                              : null,
                        ),
                        title: Text(data['name'] ?? ''),
                        subtitle: Text('CLASS : ${data['class'] ?? ''}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditStudent(
                                      documentId: document.id, 
                                      classname: findUsers[index]['class'] ?? '',
                                      guardian: findUsers[index]['guardian'] ?? '',
                                      name: findUsers[index]['name'] ?? '',
                                      number: findUsers[index]['number'] ?? '',
                                      photo: findUsers[index]['photo'] ?? '',
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                deleteStudent(context, document);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (ctr) => StudentDetails(
                                stdetails: document,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteStudent(BuildContext ctx, DocumentSnapshot document) {
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Do You Want to delete the record?'),
          actions: [
            TextButton(
              onPressed: () {
                detectedYes(ctx, document);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void detectedYes(BuildContext ctx, DocumentSnapshot document) async {
    await user.doc(document.id).delete();
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text("Successfully Deleted"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(ctx).pop();
  }
}

