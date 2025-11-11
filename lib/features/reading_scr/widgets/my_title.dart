import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTitle extends StatelessWidget {
  final String title;
  const MyTitle({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 20),
      child: SelectableText(title, style: TextStyle(fontSize: 40)),
    );
  }
}
