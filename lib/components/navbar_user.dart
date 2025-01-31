import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

class BottomNavUser extends StatelessWidget {
  final int selectedItem;
  final Function(int) onItemTapped;

  const BottomNavUser({
    super.key,
    required this.selectedItem,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      backgroundColor: Colors.white,
      showSelectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(SolarIconsOutline.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(SolarIconsOutline.document1), label: 'Histori'),
        // BottomNavigationBarItem(
        //     icon: Icon(SolarIconsOutline.user), label: 'Profile'),
      ],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black26,
      currentIndex: selectedItem,
      onTap: onItemTapped,
    );
  }
}
