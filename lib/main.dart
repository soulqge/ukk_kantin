import 'package:flutter/material.dart';
import 'package:ukk_kantin/pages/admin/home/home_admin.dart';
import 'package:ukk_kantin/pages/admin/menu_admin/add_menu.dart';
import 'package:ukk_kantin/pages/choicePage.dart';
import 'package:ukk_kantin/pages/loginPage.dart';
import 'package:ukk_kantin/pages/signupPage.dart';
import 'package:ukk_kantin/pages/user/home/homePageUser.dart';

void main() { 
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home_admin',
    routes: {
      '/login': (context) => LoginPage(),
      '/signup': (context) => SignupPage(),
      '/choice': (context) => Choicepage(),
      '/home_user': (context) => Homepageuser(),
      '/home_admin':(context) => HomeAdminPage(),
      '/tambah_menu': (context) => AddMenu()
    },
  ));
}
