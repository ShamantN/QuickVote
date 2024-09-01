import 'package:firstfiremusic/login/new_register.dart';
import 'package:firstfiremusic/login/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewUserPage extends StatelessWidget {
  const NewUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color.fromARGB(255, 15, 134, 231),
      body: Center(
        child: Column(
          children: [
            Text(
              "Welcome to",
              style: TextStyle(fontFamily: "Helvetica", color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Text(
              "Campaigner",
              style: TextStyle(
                  fontSize: 40,
                  fontFamily: "Helvetica",
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "An online voting app",
              style: TextStyle(
                color: Colors.white70,
                fontFamily: "Helvetica",
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset(
                "assets/vote_bg.png",
              ),
            ),
            const SizedBox(height: 90),
            RawMaterialButton(
              onPressed: () {
                HapticFeedback.vibrate();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Register(),
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
                );
              },
              textStyle: TextStyle(
                  fontFamily: "Helvetica",
                  color: Color.fromARGB(255, 15, 134, 231),
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
              fillColor: Colors.white,
              constraints: BoxConstraints(minWidth: 400.0, minHeight: 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Text("Sign up"),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style:
                      TextStyle(color: Colors.white70, fontFamily: "Helvetica"),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animate, secondaryAnimate) =>
                                SignInPage(),
                            transitionsBuilder:
                                (context, animate, secondaryAnimate, child) {
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
                    " Sign in",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Helvetica"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
