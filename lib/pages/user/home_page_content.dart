import 'package:flutter/material.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/hello_user.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/home_hint.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/search_bar_user.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/stan.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HelloUser(),
            SizedBox(height: 48),
            SearchBarUser(),
            SizedBox(height: 28),
            HomeHint(hintHome: "Untuk Kamu"),
            SizedBox(height: 4),
            Stan(), // Stan remains scrollable on its own
          ],
        ),
      ),
    );
  }
}
