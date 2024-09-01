// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstfiremusic/database/checker.dart';
import 'package:firstfiremusic/login/new_register.dart';
import 'package:firstfiremusic/selection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final FirebaseAuth authenticator = FirebaseAuth.instance;
  bool loader = false;
  bool showPwd = true;
  Check checker = Check();
  var _myBox = Hive.box('checkLogin');

  @override
  void initState() {
    if (_myBox.get('checkLogin') == null) {
      checker.createData();
    } else {
      checker.readLog();
    }
    super.initState();
  }

  Future<void> signIn() async {
    String email = emailController.text.trim();
    String password = pwdController.text.trim();

    try {
      setState(() {
        loader = true;
      });
      checker.store = 1;
      checker.writeLog();
      UserCredential userCredential = await authenticator
          .signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        loader = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PopScope(child: HomeScreen(), canPop: false),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1, 0);
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
    } on FirebaseAuthException catch (error) {
      String errorMessage;
      if (error.code == 'user-not-found') {
        errorMessage = " The entered E-mail was not found";
        setState(() {
          loader = false;
        });
      } else if (error.code == 'wrong-password') {
        errorMessage = "The password you have entered is incorrect";
        setState(() {
          loader = false;
        });
      } else {
        errorMessage = "Invalid username/password, please try again.";
        setState(() {
          loader = false;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.red),
        ),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sign in",
              style: TextStyle(
                  fontFamily: "Helvetica",
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Enter all the required details, to enter the app.",
              style: TextStyle(
                  color: Colors.white70, fontFamily: "Helvetica", fontSize: 17),
            ),
          ],
        ),
        toolbarHeight: 180,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 15, 134, 231),
      ),
      body: Stack(children: [
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 110, left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "E-mail ID",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: const Color.fromARGB(255, 129, 129, 129)),
                      ),
                      TextField(
                        focusNode: emailFocus,
                        controller: emailController,
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(passwordFocus);
                        },
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.email),
                            border: InputBorder.none,
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2))),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 30, right: 30, bottom: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: const Color.fromARGB(255, 129, 129, 129)),
                      ),
                      TextField(
                        obscureText: showPwd,
                        controller: pwdController,
                        focusNode: passwordFocus,
                        cursorColor: Colors.black,
                        autocorrect: false,
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showPwd = !showPwd;
                                });
                              },
                              child: showPwd
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            ),
                            border: InputBorder.none,
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2))),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 250),
                  child: RawMaterialButton(
                    onPressed: () {
                      HapticFeedback.vibrate();
                      FocusScope.of(context).unfocus();
                      signIn();
                    },
                    textStyle: TextStyle(
                        fontFamily: "Helvetica",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                    fillColor: Color.fromARGB(255, 15, 134, 231),
                    constraints: BoxConstraints(minWidth: 400.0, minHeight: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Text("Sign in"),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                          color: Colors.black87, fontFamily: "Helvetica"),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animate, secondaryAnimate) =>
                                        Register(),
                                transitionsBuilder: (context, animate,
                                    secondaryAnimate, child) {
                                  const start = Offset(1, 0);
                                  const over = Offset.zero;
                                  const speed = Curves.easeInOut;

                                  var tweek = Tween(begin: start, end: over)
                                      .chain(CurveTween(curve: speed));

                                  return SlideTransition(
                                    position: animate.drive(tweek),
                                    child: child,
                                  );
                                }));
                      },
                      child: Text(
                        " Sign up",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Helvetica"),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        if (loader)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.green, size: 50),
              ),
            ),
          ),
      ]),
    );
  }
}
