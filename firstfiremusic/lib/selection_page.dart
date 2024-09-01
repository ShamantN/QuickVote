import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firstfiremusic/bottom_bar_widget.dart';
import 'package:firstfiremusic/login/new_user.dart';
import 'package:firstfiremusic/voting_area/results.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storageInstance = FirebaseFirestore.instance;
  final authInstance = FirebaseAuth.instance;

  void logout() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: Text(
              "Are you sure you want to logout?",
              style: TextStyle(
                  fontSize: 19,
                  fontFamily: "Helvetica",
                  fontWeight: FontWeight.bold),
            ),
            content: Row(
              children: [
                RawMaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  fillColor: Colors.red,
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    try {
                      await authInstance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, animation,
                                      secondaryAnimation) =>
                                  PopScope(child: NewUserPage(), canPop: false),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(-1, 0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              }),
                          (Route<dynamic> route) => false);
                    } catch (e) {}
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(fontFamily: "Helvetica"),
                  ),
                ),
                const SizedBox(
                  width: 107,
                ),
                RawMaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  fillColor: Colors.green,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  child: Text("No", style: TextStyle(fontFamily: "Helvetica")),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            logout();
          },
          icon: Icon(Icons.logout),
          color: Colors.black,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ))
        ],
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 15, 134, 231),
        title: Text(
          "Welcome, E-voter!",
          style: TextStyle(
              fontFamily: "Helvetica",
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 13, right: 13, top: 13, bottom: 13),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 245, 240, 220)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Image.asset("assets/cast_vote.png"),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "If you want to cast your vote",
                        style: TextStyle(
                            fontFamily: "Helvetica",
                            color: const Color.fromARGB(168, 11, 11, 11),
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 20),
                      RawMaterialButton(
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        Info(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(0, -1);
                                  const end = Offset.zero;
                                  const curve = Curves.decelerate;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ));
                        },
                        fillColor: const Color.fromARGB(255, 15, 134, 231),
                        constraints:
                            BoxConstraints(minWidth: 370, minHeight: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          "Cast Vote",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 13),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 255, 178, 204)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 60),
                          child: Image.asset("assets/view_results_pic.png"),
                        ),
                        Text(
                          "If you want to view the results",
                          style: TextStyle(
                              fontFamily: "Helvetica",
                              fontSize: 18,
                              color: const Color.fromARGB(168, 11, 11, 11)),
                        ),
                        const SizedBox(height: 20),
                        RawMaterialButton(
                          onPressed: () {
                            HapticFeedback.heavyImpact();
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      ResultsPage(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(0, 1);
                                    const end = Offset.zero;
                                    const curve = Curves.decelerate;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ));
                          },
                          fillColor: const Color.fromARGB(255, 15, 134, 231),
                          constraints: BoxConstraints(
                              minWidth: double.infinity, minHeight: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            "View Votes",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// .collections() is used to get the path of the stored data
// snapShot tells us if connection was successfull