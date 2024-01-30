import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Gridlist extends StatelessWidget {
  const Gridlist({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference user =
        FirebaseFirestore.instance.collection('user');

    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: user.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      final DocumentSnapshot donorsnap =
                          snapshot.data!.docs[index];
                      return Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: FileImage(
                                  File(donorsnap['image']),
                                ),
                              ),
                            ),
                            Text(donorsnap['name']),
                            Text(donorsnap['class']),
                          ],
                        ),
                      );
                    });
              }

              return Container();
            }));
  }
}
