import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/navbar_user.dart';
import 'package:ukk_kantin/components/user_components/hello_user.dart';

class Homepageuser extends StatefulWidget {
  const Homepageuser({super.key});

  @override
  State<Homepageuser> createState() => _HomepageuserState();
}

class _HomepageuserState extends State<Homepageuser> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 243, 240, 1),
        body: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              HelloUser()
            ],
          ),
        ),
        bottomNavigationBar: BottomNavUser(selectedItem: 0),
      ),
    );
  }
}
