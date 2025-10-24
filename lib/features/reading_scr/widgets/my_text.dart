import 'package:flutter/cupertino.dart';

class MyText extends StatelessWidget {
  final String text;
  const MyText({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 50));
  }
}
