import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/hello_user.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/search_bar_user.dart';
import 'package:ukk_kantin/pages/user/home/edit_siswa_user.dart';
import 'package:ukk_kantin/pages/user/home/stan.dart';
import 'package:ukk_kantin/services/api_services_user.dart';

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
  String namaSiswa = "Loading...";
  String searchQuery = "";
  List<Map<String, dynamic>> stanList = [];
  bool isLoading = true;
  List<Map<String, dynamic>> _siswaList = [];

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login_siswa");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStans();
    loadUserData();
  }

  Future<void> fetchStans() async {
    final api = ApiServicesUser();
    final result = await api.getAllStan();
    if (mounted) {
      setState(() {
        stanList = List<Map<String, dynamic>>.from(result);
        isLoading = false;
      });
    }
  }

  void navigateToStan(int stanId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DefaultTabController(
          length: 3,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SearchBarUser(
                      width: double.infinity,
                      onSearch: (query) {
                        setState(() {
                          searchQuery = query.toLowerCase();
                        });
                      },
                    ),
                  ),
                  TabBar(
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
                        Stan(stanId: stanId, searchQuery: searchQuery),
                        Stan(
                            stanId: stanId,
                            category: "makanan",
                            searchQuery: searchQuery),
                        Stan(
                            stanId: stanId,
                            category: "minuman",
                            searchQuery: searchQuery),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editSiswa() async {
    if (_siswaList.isNotEmpty) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FormEditSiswaUser(siswaData: _siswaList[0])),
      );

      if (result == true) {
        loadUserData();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(240, 94, 94, 1),
            content: Text(
              'Data Siswa tidak ditemukan',
              style: GoogleFonts.nunitoSans(),
            )),
      );
    }
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username") ?? "Siswa";
    final apiService = ApiServicesUser();

    final List<Map<String, dynamic>> siswaList =
        List<Map<String, dynamic>>.from(await apiService.getProfile());

    setState(() {
      _siswaList = siswaList;
      namaSiswa = stanList.isNotEmpty
          ? stanList[0]["nama_siswa"] ?? username
          : username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: Color.fromRGBO(240, 94, 94, 1),
          ))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: HelloUser(
                  user: widget.userName,
                  icon: Icons.person,
                  iconColor: Color.fromRGBO(240, 94, 94, 1),
                  onEdit: _editSiswa,
                  onLogout: logout,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text("Pilih Stan",
                    style: GoogleFonts.nunitoSans(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: stanList.length,
                  itemBuilder: (context, index) {
                    final stan = stanList[index];
                    return GestureDetector(
                      onTap: () => navigateToStan(stan["id"]),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            stan["nama_stan"] ?? "Stan",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
