import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EndReadingButton extends StatelessWidget {
  const EndReadingButton({super.key});

  Future<void> _onPressed(BuildContext context) async {
    final Color? picked = await showEndWindow(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text('Закончить чтение'),
      onPressed: () => _onPressed(context),
    );
  }

  Future<Color?> showEndWindow({required BuildContext context}) async {
    Color? returnColor; // ← что вернём
    Color pickerColor = Color.fromRGBO(127, 127, 127, 1);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите цвет'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) => pickerColor = color,
            enableAlpha: false,
            labelTypes: [],
            pickerAreaHeightPercent: 1,
          ),
        ),
        actions: [
          // Кнопка "Отмена"
          TextButton(
            onPressed: () {
              returnColor = null;
              Navigator.of(context).pop();
            },
            child: const Text('Отмена'),
          ),

          // Кнопка "Выбрать"
          ElevatedButton(
            onPressed: () {
              returnColor = pickerColor; // ← явно: возвращаем выбранный
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Выбрать'),
          ),
        ],
      ),
    );

    return returnColor;
  }
}
