import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NicknameWidget extends StatefulWidget {
  const NicknameWidget({super.key});

  @override
  State<NicknameWidget> createState() => _NicknameWidgetState();
}

class _NicknameWidgetState extends State<NicknameWidget> {
  static const String _keyNickname = 'user_nickname';
  String _nickname = "Гость";
  bool _isEditing = false;
  late TextEditingController _controller;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadNickname(); // Загружаем при старте
  }

  // === Загрузка ника из хранилища ===
  Future<void> _loadNickname() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _nickname = _prefs.getString(_keyNickname) ?? "Гость";
      _controller.text = _nickname;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Убираем старый
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.black)),
        duration: const Duration(seconds: 2),

        backgroundColor: Colors.white60,
      ),
    );
  }

  // === Сохранение ника ===
  Future<void> _saveNickname(String newNickname) async {
    final trimmed = newNickname.trim();
    final nickname = trimmed.isEmpty ? "Никнейм" : trimmed;
    if (nickname.length > 16) {
      _showSnackBar('Ник должен быть не длиннее 16 символов');
      return;
    }

    // Сохраняем в SharedPreferences
    await _prefs.setString(_keyNickname, nickname);

    setState(() {
      _nickname = nickname;
      _controller.text = nickname;
      _isEditing = false;
    });
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _controller.text = _nickname;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _controller.text = _nickname;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 8),
      child: Row(
        children: [
          Expanded(
            child: _isEditing
                ? TextField(
                    controller: _controller,
                    autofocus: true,
                    maxLength: 20,
                    decoration: const InputDecoration(
                      hintText: "Введите ник",
                      counterText: "",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: _saveNickname,
                  )
                : Text(
                    _nickname,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                  ),
          ),

          _isEditing
              ? Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () => _saveNickname(_controller.text),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: _cancelEditing,
                    ),
                  ],
                )
              : IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: _startEditing,
                ),
        ],
      ),
    );
  }
}
