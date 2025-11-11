import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyText extends StatelessWidget {
  final String text;
  final double fontSize;
  const MyText({super.key, required this.text, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return SelectableText(text, style: TextStyle(fontSize: fontSize));
  }
}
