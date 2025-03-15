import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/hello_user.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/search_bar_user.dart';
import 'package:ukk_kantin/pages/user/pesan/stan.dart';

class HomePageContent extends StatefulWidget {
  final String userName;
  final String makerId;

  const HomePageContent({
    super.key,
    required this.userName,
    required this.makerId,
  });

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String searchQuery = "";

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login_siswa");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HelloUser(
                  user: widget.userName,
                  icon: Icons.person,
                  iconColor: Colors.white,
                  onLogout: logout,
                ),
                const SizedBox(height: 24),
                SearchBarUser(
                  width: double.infinity,
                  onSearch: (query) {
                    setState(() {
                      searchQuery = query.toLowerCase();
                    });
                  },
                ),
              ],
            ),
          ),
          const TabBar(
            labelColor: Colors.black,
            indicatorColor: Color.fromRGBO(240, 94, 94, 1),
            tabs: [
              Tab(text: "Semua Menu"),
              Tab(text: "Makanan"),
              Tab(text: "Minuman"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Stan(searchQuery: searchQuery),
                Stan(category: "makanan", searchQuery: searchQuery),
                Stan(category: "minuman", searchQuery: searchQuery),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
