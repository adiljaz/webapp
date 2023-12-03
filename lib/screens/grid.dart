import 'dart:io';

import 'package:flutter/material.dart';
import 'package:h1/function/functions.dart';
import 'package:h1/screens/studentdetails.dart';

class Gridlist extends StatelessWidget {
  const Gridlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: studentList,
          builder: (context, value, child) {
            return GridView.builder(
                itemCount: value.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final SD = value[index];

                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  StudentDetails(stdetails: SD)));
                        },
                        child: Card(
                          color: const Color.fromARGB(255, 193, 228, 244),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: FileImage(
                                    File(SD.imagex),
                                  ),
                                ),
                              ),
                              Text(SD.name),
                              Text(SD.classname),
                            ],
                          ),
                        ),
                      ));
                });
          }),
    );
  }
}
