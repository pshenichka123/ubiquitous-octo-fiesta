import 'package:app/dto/text_dto.dart';
import 'package:flutter/material.dart';
import '../widgets/my_text.dart';
import '../widgets/my_title.dart';

class ReadingScreen extends StatelessWidget {
  final Map<String, dynamic>? args;

  const ReadingScreen({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    final double fontSize = args?['fontSize'];
    final TextDto textDto = args?['textDto'];
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            MyTitle(title: textDto.title),
            MyText(text: textDto.text),
            GestureDetector(
              child: Text('Закончить чтение'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
