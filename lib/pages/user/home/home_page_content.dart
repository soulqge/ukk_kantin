import 'package:flutter/material.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/hello_user.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/home_hint.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/search_bar_user.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/stan.dart';

class HomePageContent extends StatelessWidget {
  final String userName; // <-- Receive username
  final String makerId;

  const HomePageContent({super.key, required this.userName, required this.makerId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HelloUser(
                user: userName, icon: Icons.person, iconColor: Colors.white),
            SizedBox(height: 48),
            SearchBarUser(width: double.infinity),
            SizedBox(height: 28),
            HomeHint(hintHome: "Untuk Kamu"),
            SizedBox(height: 4),
            Stan(),
          ],
        ),
      ),
    );
  }
}
