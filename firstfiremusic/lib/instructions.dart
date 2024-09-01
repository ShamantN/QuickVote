import 'package:flutter/material.dart';

class Instructions extends StatelessWidget {
  const Instructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 300,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 15, 134, 231),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("About",
                style: TextStyle(
                    fontFamily: "Helvetica",
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 50)),
            Text(
              "This is to help you understand and get started with this app.",
              style: TextStyle(
                  fontFamily: "Helvetica", fontSize: 14, color: Colors.white70),
            )
          ],
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20),
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Text(
                "1) Once you have pressed yes in the confirmation dialog box, your vote will be registered in the databse and the action is irreversible.",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black, fontSize: 20, fontFamily: "Helvetica"),
              ),
              Text(
                "2) Your E-mail ID along with the party you voted for will be stored.",
                style: TextStyle(
                    color: Colors.black, fontSize: 20, fontFamily: "Helvetica"),
              ),
              Text(
                "3) If you have finished voting, you will no longer be able to cast your vote. You will get a notice if you have already voted.",
                style: TextStyle(
                    color: Colors.black, fontSize: 20, fontFamily: "Helvetica"),
              ),
              Text(
                "4) The results of the election will be displayed according to varying timers depending on the situation.",
                style: TextStyle(
                    color: Colors.black, fontSize: 20, fontFamily: "Helvetica"),
              ),
              Text(
                "5) This entire app was made by Shamant Nagabhushana only.",
                style: TextStyle(
                    color: Colors.black, fontSize: 20, fontFamily: "Helvetica"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
