import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ukk_kantin/pages/user/history/detail_tran_page.dart'; // Import intl

class ListTranAdmin extends StatefulWidget {
  const ListTranAdmin({super.key});

  @override
  State<ListTranAdmin> createState() => __ListTranAdminState();
}

class __ListTranAdminState extends State<ListTranAdmin> {
  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> details = [
      {
        'name': 'Pak Yoyok',
        'total': 6000,
        'tanggal': "5 Februari 2025",
        'jam': "9:30 AM",
        'status': "Dimasak",
      },
      {
        'name': 'Bu Darti',
        'total': 10000,
        'tanggal': "26 Januari 2025",
        'jam': "10:14 AM",
        'status': "Selesai",
      },
      {
        'name': 'Pak Yoyok',
        'total': 50000,
        'tanggal': "10 Desember 2024",
        'jam': "10:24 AM",
        'status': "Selesai",
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: details.length,
      itemBuilder: (context, index) {
        final detail = details[index];

        Color statusColor = detail['status'] == "Dimasak"
            ? Color.fromRGBO(240, 94, 94, 1)
            : Colors.green;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailTranPage(
                  detail: detail,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 243, 240, 1),
                borderRadius: BorderRadius.all(Radius.circular(16)),
                border: Border.all(color: Color.fromRGBO(240, 94, 94, 1))),
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                detail['name']!,
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.04,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // To be implemented
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Color.fromRGBO(240, 94, 94, 1),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "Total : ",
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              formatCurrency.format(detail['total']),
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              detail['tanggal']!,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.12,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              detail['jam']!,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.12,
                              ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor),
                              ),
                              child: Text(
                                detail['status']!,
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.12,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
