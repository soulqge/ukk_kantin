import 'package:flutter/material.dart';
import 'package:ukk_kantin/pages/choicePage.dart';
import 'package:ukk_kantin/pages/loginPage.dart';
import 'package:ukk_kantin/pages/signupPage.dart';
import 'package:ukk_kantin/pages/user-home/homePageUser.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/choice',
    routes: {
      '/login': (context) => LoginPage(),
      '/signup': (context) => SignupPage(),
      '/choice': (context) => Choicepage(),
      '/home_user': (context) => Homepageuser(),
    },
  ));
}
