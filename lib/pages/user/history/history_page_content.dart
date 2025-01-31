import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/user_components/history_page_components/button_search.dart';
import 'package:ukk_kantin/components/user_components/history_page_components/hello_act.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/search_bar_user.dart';
import 'package:ukk_kantin/pages/user/history/list_tran.dart';

class HistoryPageContent extends StatelessWidget {
  const HistoryPageContent({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HelloAct(),
            SizedBox(height: 12),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SearchBarUser(
                    width: MediaQuery.sizeOf(context).width * 0.6,
                  ),
                  ButtonSearch(icon: SolarIconsBold.filter),
                  ButtonSearch(icon: SolarIconsBold.stopwatch)
                ],
              ),
            ),
            SizedBox(height: 24),
            ListTran()
          ],
        ),
      ),
    );
  }
}
