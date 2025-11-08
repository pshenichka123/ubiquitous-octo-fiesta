import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyText extends StatefulWidget {
  final String text;
  final ScrollController scrollController;
  final double startPosition;
  const MyText({
    super.key,
    required this.text,
    required this.scrollController,
    required this.startPosition,
  });

  @override
  MyTextState createState() => MyTextState();
}

class MyTextState extends State<MyText> {
  late double fontSize;
  bool _isLoading = true; // <-- Добавляем флаг загрузки
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    String? strFontSize = await _storage.read(key: 'fontSize');
    if (strFontSize == null) {
      fontSize = 16.0;
      await _storage.write(key: "fontSize", value: "16.0");
    } else {
      fontSize = double.parse(strFontSize);
    }

    // Обновляем UI после загрузки

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final maxScroll = widget.scrollController.position.maxScrollExtent;
        final targetOffset = maxScroll * (widget.startPosition / 100);
        widget.scrollController.jumpTo(targetOffset.clamp(0.0, maxScroll));
      });
    });
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        children: [
          // Показываем индикатор или текст
          _isLoading
              ? const CupertinoActivityIndicator() // или CircularProgressIndicator()
              : Text(widget.text, style: TextStyle(fontSize: fontSize)),

          const SizedBox(height: 20),

          GestureDetector(
            child: const Text('Закончить чтение'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
