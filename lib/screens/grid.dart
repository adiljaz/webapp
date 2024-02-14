

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:h1/screens/studentdetails.dart';


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
                      return InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> StudentDetails(stdetails: donorsnap)));
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                   height: 100,
                                    width: 100 ,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                                 
                                 child: Image.network(donorsnap['image'],fit: BoxFit.cover,)
                                ),
                              ),
                              Text(donorsnap['name']),
                              Text(donorsnap['class']),
                            ],
                          ),
                        ),
                      );
                    });
              }

              return Container();
            }));
  }
}
