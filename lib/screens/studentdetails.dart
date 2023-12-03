import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentDetails extends StatelessWidget {
  final stdetails;
  const StudentDetails({super.key, required this.stdetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text('Student Details'),
          centerTitle: true,
        ),
        body: Center(
          child: SizedBox(
            height: 400,
            width: 400,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(8), // Adjust the radius as needed
                    child: Image.file(
                      File(stdetails.imagex),
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name :  ${stdetails.name}',
                          style: GoogleFonts.alice(
                              fontSize: 23,
                              color: const Color.fromARGB(255, 3, 61, 4))),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Class :  ${stdetails.classname}',
                          style: GoogleFonts.alice(
                              fontSize: 23,
                              color: const Color.fromARGB(255, 95, 4, 111))),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Parent :  ${stdetails.father}',
                          style: GoogleFonts.alice(
                              fontSize: 23,
                              color: const Color.fromARGB(255, 4, 9, 111))),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Mobile :  ${stdetails.pnumber}',
                          style: GoogleFonts.alice(
                              fontSize: 23,
                              color: const Color.fromARGB(255, 111, 4, 68))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
