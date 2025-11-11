import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:second_try/api/my_dio.dart';
import '../../../dtos/text_dto.dart';
import '../../../dtos/text_history_dto.dart';
import '../../../router/router/RouteNames.dart';

class ReadingHistoryWidget extends StatefulWidget {
  const ReadingHistoryWidget({super.key});

  @override
  _ReadingHistoryWidgetState createState() => _ReadingHistoryWidgetState();
}

class _ReadingHistoryWidgetState extends State<ReadingHistoryWidget>
    with WidgetsBindingObserver {
  final Dio _dio = MyDio.instance();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Кэшируем данные
  TextHistoryDto? _history;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadHistory(); // Загружаем один раз
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Метод для загрузки (можно вызывать повторно)
  Future<void> _loadHistory() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      var idStr = await _storage.read(key: 'id');
      int id;

      if (idStr == null) {
        final response = await _dio.get("/getId");
        final data = response.data as Map<String, dynamic>;
        idStr = data['id'].toString();
        await _storage.write(key: 'id', value: idStr);
      }

      id = int.parse(idStr);

      final response = await _dio.post('/getHistory', data: {'id': id});
      final TextHistoryDto textHistoryDto = TextHistoryDto.fromJson(
        response.data['textHistoryDto'],
      );

      if (mounted) {
        setState(() {
          _history = textHistoryDto;
          _isLoading = false;
        });
      }
    } catch (e) {
      log('Error loading history: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  // Pull-to-refresh
  Future<void> _onRefresh() async {
    await _loadHistory();
  }

  Future<void> _onPressed(int textId, double progress) async {
    try {
      if (!context.mounted) {
        log('Ошибкаsdcsdcsdc');
        return;
      }
      final response = await _dio.post('/textById', data: {'id': textId});
      final data = response.data as Map<String, dynamic>;
      TextDto textDto = TextDto.fromJson(data["textDto"]);
      final String? strFontSize = await _storage.read(key: "fontSize");
      final double fontSize = double.parse(strFontSize!);
      await Navigator.pushNamed(
        context,
        RouteNames.readingScreen,
        arguments: {
          'textDto': textDto,
          'progress': progress,
          'fontSize': fontSize,
        },
      );
      await _onRefresh();
    } catch (e) {
      log("error");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка загрузки текста: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(onRefresh: _onRefresh, child: _buildContent());
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Ошибка при загрузке истории"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadHistory,
              child: const Text("Повторить"),
            ),
          ],
        ),
      );
    }

    if (_history == null || _history!.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("История пуста"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadHistory,
              child: const Text("Повторить"),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics:
          const AlwaysScrollableScrollPhysics(), // Важно для RefreshIndicator
      itemCount: _history!.items.length,
      itemBuilder: (context, index) {
        final item = _history!.items[index];
        return ListTile(
          title: Text(item.title),
          subtitle: Text(
            'Последнее : ${item.lastReading.year}:${item.lastReading.month}:${item.lastReading.day} ',
          ),
          trailing: Text('Прогресс: ${item.progress.toStringAsFixed(0)}%'),
          onTap: () {
            _onPressed(item.id, item.progress);
          },
        );
      },
    );
  }
}
