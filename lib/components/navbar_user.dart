// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';


class BottomNavUser extends StatefulWidget {
  final int selectedItem;
  const BottomNavUser({super.key, required this.selectedItem});

  @override
  State<BottomNavUser> createState() => _BottomNavUserState();
}

class _BottomNavUserState extends State<BottomNavUser> {

  int _currentIndex = 0;

  void changeSelectedNavBar(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/histori');
    }
    else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/account');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      backgroundColor:  Colors.white,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(SolarIconsOutline.home),
          label: 'Home'
        ),
        BottomNavigationBarItem(
          icon: Icon(SolarIconsOutline.document1),
          label: 'Histori'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Profile'
        ),
      ],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black26,
      currentIndex: widget.selectedItem,
      onTap: changeSelectedNavBar,
    );
  }
}