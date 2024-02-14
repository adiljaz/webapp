import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:h1/screens/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBndG0zLqzgCXGV2b7fu8EmyQhBa38HeBI",
            appId: "1:1024565924534:web:620648ec15083d0279cc17",
            messagingSenderId: "1024565924534",
            storageBucket: "student-record-95722.appspot.com",
             authDomain: "student-record-95722.firebaseapp.com",
            projectId: "student-record-95722"));
  }

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: const splashScreen(),
    );
  }
}
