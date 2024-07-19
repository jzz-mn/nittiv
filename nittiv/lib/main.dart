import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ui/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize firebase

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBE8ok9GKfWK5AH_8ADEcM7RgQGp4lyY8U",
        authDomain: "nittiv-project-2024.firebaseapp.com",
        projectId: "nittiv-project-2024",
        storageBucket: "nittiv-project-2024.appspot.com",
        messagingSenderId: "85086430378",
        appId: "1:85086430378:web:784b903414ed0846275cd3"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nittiv',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Poppins',
      ),
      home: const LoadingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
