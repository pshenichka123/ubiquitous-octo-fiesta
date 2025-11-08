import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../features/main_scr/widgets/theme_switch.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key}); // Убрали ненужный конструктор с context

  @override
  State<SettingsWidget> createState() => SettingsWindowState();
}

class SettingsWindowState extends State<SettingsWidget> {
  double _fontSize = 16.0;
  bool _isLoading = true;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    try {
      final double fontSize = double.parse(
        (await _storage.read(key: "fontSize") as String),
      );
      setState(() {
        _fontSize = fontSize;
        _isLoading = false;
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveFontSize(double fontSize) async {
    try {
      await _storage.write(key: "fontSize", value: _fontSize.toString());
      log('saved');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Сохранен размер текста: ${fontSize.toInt()}'),
          duration: Duration(seconds: 1),
        ),
      );
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
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 190,
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
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 5),
                      child: GestureDetector(
                        child: const Text(
                          "Сохранить",
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () => _saveFontSize(_fontSize),
                      ),
                    ),
                  ),
                ),
                const Center(child: ThemeSwitch()),
              ],
            ),
    );
  }
}
