import 'package:firstfiremusic/instructions.dart';
import 'package:firstfiremusic/navigation_bar/bottom_bar.dart';
import 'package:firstfiremusic/voting_area/CastVote.dart';
import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  int selectedIndex = 0;

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> pages = [const Castvote(), const Instructions()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomBar(onTabChange: (index) => changePage(index)),
      body: pages[selectedIndex],
    );
  }
}
