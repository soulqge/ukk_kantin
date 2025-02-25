import 'package:flutter/material.dart';
import 'package:ukk_kantin/pages/admin/home/home_admin.dart';
import 'package:ukk_kantin/pages/admin/menu_admin/add_menu.dart';
import 'package:ukk_kantin/pages/admin/siswa/tambah_siswa.dart';
import 'package:ukk_kantin/pages/login/choicePage.dart';
import 'package:ukk_kantin/pages/login/loginPage.dart';
import 'package:ukk_kantin/pages/login/signupPage.dart';
import 'package:ukk_kantin/pages/login/signupPage_admin.dart';
import 'package:ukk_kantin/pages/user/home/homePageUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/choice',
    routes: {
      '/login': (context) => LoginPage(),
      '/signup_siswa': (context) => SignupPage(),
      '/signup_admin': (context) => SignupPageAdmin(),
      '/choice': (context) => ChoicePage(),
      '/home_user': (context) => Homepageuser(),
      '/home_admin': (context) => HomeAdminPage(),
      '/tambah_menu': (context) => AddMenu(),
      '/tambah_siswa': (context) => TambahSiswaAdmin(),
      
    },
  ));
}
