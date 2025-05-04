import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_kantin/components/admin_components/admin_hint.dart';
import 'package:ukk_kantin/components/admin_components/dropdown_bulan.dart';
import 'package:ukk_kantin/components/admin_components/hello_admin_logout.dart';
import 'package:ukk_kantin/components/admin_components/order_box.dart';
import 'package:ukk_kantin/components/admin_components/pemasukan.dart';
import 'package:ukk_kantin/pages/admin/menu_admin/edit_stan.dart';
import 'package:ukk_kantin/services/api_services.dart';

class HomeAdminContent extends StatefulWidget {
  const HomeAdminContent({super.key});

  @override
  State<HomeAdminContent> createState() => _HomeAdminContentState();
}

class _HomeAdminContentState extends State<HomeAdminContent> {
  String kantinName = "Loading...";
  int _pemasukan = 0;
  int _pemasukanBulanIni = 0;
  List<Map<String, dynamic>> _stanList = [];
  int _countOrderBelum = 0;
  int _countOrderSelesai = 0;
  String _selectedMonth = DateFormat('yyyy-MM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    loadAdminData();
    fetchPemasukanBulanIni();
    fetchPemasukan();
    _fetchOrderBelum();
    _fetchOrderSelesai();
  }

  Future<void> loadAdminData() async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username") ?? "Kantin";
    final apiService = ApiServiceAdmin();

    final List<Map<String, dynamic>> stanList =
        List<Map<String, dynamic>>.from(await apiService.getStan());

    setState(() {
      _stanList = stanList;
      kantinName = stanList.isNotEmpty
          ? stanList[0]["nama_pemilik"] ?? username
          : username;
    });
  }

  String getCurrentMonth() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM').format(now);
  }

  Future<void> fetchPemasukanBulanIni() async {
    final apiService = ApiServiceAdmin();
    String bulanIni = getCurrentMonth();

    final rekapData = await apiService.getPemasukan(bulanIni);

    if (rekapData.isNotEmpty && rekapData.containsKey("total_pemasukan")) {
      setState(() {
        _pemasukanBulanIni = rekapData["total_pemasukan"];
      });
    }
  }

  Future<void> fetchPemasukan([String? month]) async {
    final api = ApiServiceAdmin();
    final bulan = month ?? _selectedMonth; // use passed in month or default

    final rekapData = await api.getPemasukan(bulan);
    if (rekapData.isNotEmpty && rekapData.containsKey("total_pemasukan")) {
      setState(() {
        _pemasukan = rekapData["total_pemasukan"];
      });
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login_admin");
    }
  }

  void _editStan() async {
    if (_stanList.isNotEmpty) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditStan(stanData: _stanList[0]),
        ),
      );

      if (result == true) {
        loadAdminData();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(240, 94, 94, 1),
            content: Text(
              'Data stan tidak ditemukan',
              style: GoogleFonts.nunitoSans(),
            )),
      );
    }
  }

  Future<void> _fetchOrderBelum() async {
    final orderList = await ApiServiceAdmin().getOrderAdminBelum();
    setState(() {
      _countOrderBelum = orderList.length;
    });
  }

  Future<void> _fetchOrderSelesai() async {
    final orderList = await ApiServiceAdmin().getOrderAdminSelesai();
    setState(() {
      _countOrderSelesai = orderList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayName =
        "Hello, \n${kantinName[0].toUpperCase()}${kantinName.substring(1)}";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HelloAdminLogout(
                kantin: displayName,
                icon: Icons.person,
                iconColor: Color.fromRGBO(240, 94, 94, 1),
                onEdit: _editStan, // Panggil fungsi _editStan
                onLogout: logout,
              ),
              const SizedBox(height: 16),
              OrderBox(running: _countOrderBelum, request: _countOrderSelesai),
              const SizedBox(height: 16),
              Pemasukan(
                penghasilan: _pemasukanBulanIni,
                hint: "Pemasukan Bulan Ini",
              ),
              const SizedBox(height: 34),
              const AdminHint(hint: "Histori Transaksi"),
              const SizedBox(height: 12),
              DropdownBulan(
                selectedMonth: _selectedMonth,
                onChanged: (month) {
                  setState(() => _selectedMonth = month);
                  fetchPemasukan();
                },
              ),
              const SizedBox(height: 16),
              Pemasukan(
                penghasilan: _pemasukan,
                hint:
                    "Pemasukan Bulan ${DateFormat('MMMM', 'id').format(DateTime.parse("$_selectedMonth-01"))}",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
