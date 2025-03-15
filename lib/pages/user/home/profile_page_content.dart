import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_kantin/services/api_services.dart';

class TestStan extends StatefulWidget {
  const TestStan({
    super.key,
  });

  @override
  State<TestStan> createState() => _StanState();
}

class _StanState extends State<TestStan> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStan();
  }

  Future<void> fetchStan() async {
    final apiService = ApiService();
    try {
      List<dynamic> stan = await apiService.getAllStan();
      if (mounted) {
        setState(() {
          items = List<Map<String, dynamic>>.from(stan);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      debugPrint("Error fetching menus: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];

              return Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item["nama_stan"],
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("${item["nama_pemilik"]}",
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color.fromRGBO(
                                          240, 94, 94, 1))),
                              const Spacer(),
                              Text((item["telp"]),
                                  style: GoogleFonts.sen(
                                      fontSize: 17.89,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
