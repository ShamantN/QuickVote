// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomBar extends StatelessWidget {
  void Function(int)? onTabChange;
  BottomBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GNav(
        mainAxisAlignment: MainAxisAlignment.center,
        tabActiveBorder: Border.all(color: Colors.black),
        tabBackgroundColor: Colors.grey.shade300,
        tabBorderRadius: 20,
        onTabChange: (index) {
          if (onTabChange != null) {
            onTabChange!(index);
          }
        },
        tabs: [
          GButton(icon: Icons.how_to_vote, text: 'Vote'),
          GButton(
            icon: Icons.info,
            text: 'About',
          )
        ],
      ),
    );
  }
}
