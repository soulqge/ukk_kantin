import 'package:flutter/material.dart';

class ButtonSearch extends StatelessWidget {
  final IconData icon;

  const ButtonSearch({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color.fromRGBO(240, 94, 94, 1)),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
