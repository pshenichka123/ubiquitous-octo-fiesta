import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:app/services/storage_service/my_storage.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key}); // Убрали ненужный конструктор с context

  @override
  State<SettingsWidget> createState() => SettingsWindowState();
}

class SettingsWindowState extends State<SettingsWidget> {
  final MyStorage _myStorage = MyStorage();
  double _fontSize = 16.0; // Начальное значение по умолчанию
  bool _isLoading = true; // Флаг для отслеживания загрузки

  @override
  void initState() {
    super.initState();
    // Загружаем начальное значение из хранилища
    _loadFontSize();
  }

  // Асинхронная загрузка размера шрифта
  Future<void> _loadFontSize() async {
    try {
      final fontSize = await _myStorage.getFontSize();
      setState(() {
        _fontSize =
            fontSize ?? 16.0; // Если null, используем значение по умолчанию
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Сохранение размера шрифта
  Future<void> _saveFontSize(double fontSize) async {
    try {
      await _myStorage.saveFontSize(fontSize);
      log('saved');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка сохранения: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator() // Показываем загрузку, пока данные не получены
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      'Едят ли мошки кошек? Едят ли кошки мошек?',
                      style: TextStyle(fontSize: _fontSize),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Text(
                  'Размер текста: ${_fontSize.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Slider(
                    value: _fontSize,
                    min: 10.0,
                    max: 50.0,
                    label: _fontSize.toStringAsFixed(1),
                    onChanged: (double value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: const Text(
                      "Сохранить",
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                    onTap: () => _saveFontSize(_fontSize),
                  ),
                ),
              ],
            ),
    );
  }
}
