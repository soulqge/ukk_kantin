import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/admin_components/hello_admin.dart';
import 'package:ukk_kantin/pages/admin/siswa/edit_siswa.dart';
import 'package:ukk_kantin/services/api_services.dart';

class SiswaAdminContent extends StatefulWidget {
  @override
  _SiswaAdminContentState createState() => _SiswaAdminContentState();
}

class _SiswaAdminContentState extends State<SiswaAdminContent> {
  late Future<List<Map<String, dynamic>>> _siswaList;
  final String baseUrlRil = "https://ukk-p2.smktelkom-mlg.sch.id/";

  @override
  void initState() {
    super.initState();
    _fetchSiswa();
  }

  void _fetchSiswa() {
    setState(() {
      _siswaList = ApiService().getSiswa();
    });
  }

  Future<void> _deleteSiswa(String siswaId) async {
    final apiService = ApiService();
    bool success = await apiService.hapusSiswa(siswaId: siswaId);

    if (success) {
      setState(() {
        _siswaList = ApiService().getSiswa();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(36, 150, 137, 1),
            content: Text(
              "Siswa berhasil dihapus",
              style: GoogleFonts.nunitoSans(),
            )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(240, 94, 94, 1),
            content: Text(
              "Gagal menghapus siswa",
              style: GoogleFonts.nunitoSans(),
            )),
      );
    }
  }

  void _editSiswa(Map<String, dynamic> siswa) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormEditSiswa(siswaData: siswa),
      ),
    );

    if (result == true) {
      _fetchSiswa();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _fetchSiswa();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: HelloAdmin(
                kantin: 'Tambah Siswa',
                icon: SolarIconsBold.addCircle,
                iconColor: Colors.red,
                route: '/tambah_siswa',
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _siswaList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Color.fromRGBO(240, 94, 94, 1),
                    ));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Terjadi kesalahan: ${snapshot.error}",
                        style: GoogleFonts.nunitoSans(),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(
                      "Tidak ada data siswa",
                      style: GoogleFonts.nunitoSans(),
                    ));
                  }

                  List<Map<String, dynamic>> siswaList = snapshot.data!;

                  return ListView.builder(
                    itemCount: siswaList.length,
                    itemBuilder: (context, index) {
                      var siswa = siswaList[index];
                      return Slidable(
                        key: ValueKey(siswa['id']),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) => _editSiswa(siswa),
                              backgroundColor: Color.fromRGBO(147, 147, 147, 1),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (_) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Hapus Siswa"),
                                    content: const Text(
                                        "Apakah Anda yakin ingin menghapus siswa ini?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Batal"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _deleteSiswa(siswa["id"].toString());
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Hapus"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              backgroundColor: Color.fromRGBO(240, 94, 94, 1),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Hapus',
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: 102,
                                  height: 102,
                                  child: siswa["foto"] == null ||
                                          siswa["foto"].isEmpty
                                      ? Image.asset("assets/noImage.png",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover)
                                      : Image.network(
                                          "$baseUrlRil${siswa["foto"]}",
                                          fit: BoxFit.cover,
                                          width: 102,
                                          height: 102,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                                      "assets/placeholder.png",
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover),
                                        ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nama Lengkap: ${siswa["nama_siswa"]}",
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Username: ${siswa["username"]}",
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Alamat: ${siswa["alamat"]}",
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
