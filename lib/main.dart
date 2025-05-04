import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // <== ADD THIS
import 'package:provider/provider.dart';
import 'package:ukk_kantin/pages/admin/diskon_admin/add_diskon.dart';
import 'package:ukk_kantin/pages/admin/home/home_admin.dart';
import 'package:ukk_kantin/pages/admin/menu_admin/add_menu.dart';
import 'package:ukk_kantin/pages/admin/siswa/tambah_siswa.dart';
import 'package:ukk_kantin/pages/login/choicePage.dart';
import 'package:ukk_kantin/pages/login/loginPage.dart';
import 'package:ukk_kantin/pages/login/loginPageAdmin.dart';
import 'package:ukk_kantin/pages/login/signupPage.dart';
import 'package:ukk_kantin/pages/login/signupPage_admin.dart';
import 'package:ukk_kantin/pages/user/checkout/cart_page.dart';
import 'package:ukk_kantin/pages/user/home/homePageUser.dart';
import 'package:ukk_kantin/provider/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/choice',
      routes: {
        '/login_siswa': (context) => LoginPage(),
        '/login_admin': (context) => Loginpageadmin(),
        '/signup_siswa': (context) => SignupPage(),
        '/signup_admin': (context) => SignupPageAdmin(),
        '/choice': (context) => ChoicePage(),
        '/home_user': (context) => Homepageuser(),
        '/home_admin': (context) => HomeAdminPage(),
        '/tambah_menu': (context) => AddMenu(),
        '/tambah_diskon': (context) => AddDiskon(),
        '/tambah_siswa': (context) => TambahSiswaAdmin(),
        '/cart_page': (context) => CartPage(),
      },
    );
  }
}
