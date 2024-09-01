// ignore_for_file: prefer_const_constructors

//import 'package:firstfiremusic/login/new_user.dart';
import 'package:firstfiremusic/login/stay_logged.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('checkLogin');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StayLoggedIn(),
      debugShowCheckedModeBanner: false,
    );
  }
}
