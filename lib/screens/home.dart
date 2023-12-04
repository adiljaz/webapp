import 'package:flutter/material.dart';
import 'package:h1/function/functions.dart';
import 'package:h1/screens/addstudnet.dart';
import 'package:h1/screens/grid.dart';
import 'package:h1/screens/search.dart';
import 'package:h1/screens/studnetlist.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  int _currentinex = 0;

  final Screens = [
    const Gridlist(),
    const StudentList(),
  ];

  @override
  Widget build(BuildContext context) {
    getstudentdata();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          'Students Record',
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctxs) => const SearchScreen()));
              },
              icon: const Icon(
                Icons.search_rounded,
                color: Colors.black,
              ))
        ],
      ),
      body: Screens[_currentinex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: true, // Show the add button
        child: FloatingActionButton(
          backgroundColor: Colors.lightBlue,
          shape: const CircleBorder(),
          onPressed: () {
            addstudent(context);
          },
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentinex,
          unselectedItemColor: Colors.black,
          onTap: (newvalue) {
            print(newvalue);
            setState(() {
              _currentinex = newvalue;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.grid_3x3), label: 'Grid'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          ]),
    );
  }

  void addstudent(ctx) {
    Navigator.of(ctx)
        .push(MaterialPageRoute(builder: (ctx) => const AddStudent()));
  }
}
