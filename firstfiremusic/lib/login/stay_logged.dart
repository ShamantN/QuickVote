import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstfiremusic/login/new_user.dart';
import 'package:firstfiremusic/selection_page.dart';
import 'package:flutter/material.dart';

class StayLoggedIn extends StatelessWidget {
  const StayLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return NewUserPage();
            }
          }
          return Center(
              child: CircularProgressIndicator(
            color: Colors.green,
          ));
        });
  }
}
