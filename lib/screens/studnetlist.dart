import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:h1/screens/edit.dart';
import 'package:h1/screens/studentdetails.dart';

class StudentList extends StatelessWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CollectionReference user =
        FirebaseFirestore.instance.collection('user');

    return StreamBuilder(
      stream: user.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(), // Placeholder for loading state
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot student = snapshot.data!.docs[index];
            return Card(
              color: Colors.lightBlue[50],
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: Container(
                                   height: 100,
                                    width: 100 ,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                                 
                                 child: Image.network(student['image'],fit: BoxFit.cover,)
                                ),
                title: Text(student['name']),
                subtitle: Text(
                  "Class: ${student['class']}",
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditStudent(
                            classname: student['class'],
                            guardian: student['guardian'],
                            name: student['name'],
                           number: student['number'],
                            photo: student['image'],
                            documentId: student.id,
                          ),
                        ));
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        deleteStudent(student.id, context);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctr) => StudentDetails(stdetails: student),
                  ));
                },
              ),
            );
          },
        );
      },
    );
  }

  void deleteStudent(String studentId, BuildContext context) {
    FirebaseFirestore.instance.collection('user').doc(studentId).delete().then((value) {
      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Successfully Deleted"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      // Show error message if deletion fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to delete student"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
}
