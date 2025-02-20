import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
        const SnackBar(content: Text("Siswa berhasil dihapus")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menghapus siswa")),
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
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Terjadi kesalahan: ${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Tidak ada data siswa"));
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
                              backgroundColor: Colors.blue,
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
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Hapus',
                            ),
                          ],
                        ),
                        child: Card(
                          color: Colors.white,
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundImage: siswa['foto'] != null &&
                                      siswa['foto'].isNotEmpty
                                  ? NetworkImage("$baseUrlRil${siswa["foto"]}")
                                  : null,
                              child:
                                  siswa['foto'] == null || siswa['foto'].isEmpty
                                      ? Text(
                                          siswa['username'][0].toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : null,
                            ),
                            title: Text(siswa['username']),
                            subtitle: Text(siswa['alamat']),
                            trailing: Text(siswa['role']),
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
