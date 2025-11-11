import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:second_try/api/my_dio.dart';
import '../../../dtos/text_dto.dart';
import '../../../dtos/text_list_dto.dart';
import '../../../router/router/RouteNames.dart';

class AllTextWidget extends StatefulWidget {
  const AllTextWidget({super.key});

  @override
  _AllTextWidgetState createState() => _AllTextWidgetState();
}

class _AllTextWidgetState extends State<AllTextWidget> {
  final Dio _dio = MyDio.instance();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Кэшируем данные
  TextListDto? _list;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTexts();
  }

  Future<void> _loadTexts() async {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _dio.post('/allTexts');
      final TextListDto textListDto = TextListDto.fromJson(
        response.data['list'],
      );

      if (mounted) {
        setState(() {
          _list = textListDto;
          _isLoading = false;
        });
      }
    } catch (e) {
      log('Error loading list: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    await _loadTexts();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(onRefresh: _onRefresh, child: _buildWidget());
  }

  Widget _buildWidget() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Ошибка при загрузке текстов"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadTexts,
              child: const Text("Повторить"),
            ),
          ],
        ),
      );
    }
    if (_list == null || _list!.items.isEmpty) {
      return const Center(child: Text("Список пуст"));
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _list?.items.length,
      itemBuilder: (context, index) {
        final item = _list!.items[index];
        return ListTile(
          title: Text(item.title),
          onTap: () {
            _onListTap(item.id);
          },
        );
      },
    );
  }

  Future<void> _onListTap(int textId) async {
    try {
      if (!context.mounted) {
        log('Ошибкаsdcsdcsdc');
        return;
      }
      final response = await _dio.post('/textById', data: {'id': textId});
      final data = response.data as Map<String, dynamic>;
      TextDto textDto = TextDto.fromJson(data["textDto"]);
      if (!mounted) return;
      final String strFontSize = await _storage.read(key: "fontSize") as String;
      final double fontSize = double.parse(strFontSize);
      Navigator.pushNamed(
        context,
        RouteNames.readingScreen,
        arguments: {'textDto': textDto, 'progress': 0.0, "fontSize": fontSize},
      );
    } catch (e) {
      log("error");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка загрузки текста: $e')));
    }
  }
}
