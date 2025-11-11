import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:second_try/features/main_scr/widgets/all_texts_widget.dart';
import '../../../dtos/text_dto.dart';
import '../../../router/router/RouteNames.dart';
import 'package:dio/dio.dart';

class ReadingWidget extends StatefulWidget {
  const ReadingWidget({super.key});

  @override
  State<ReadingWidget> createState() => _ReadingWidgetState();
}

class _ReadingWidgetState extends State<ReadingWidget> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://77.222.53.147:5000/api',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<void> _onPressed() async {
    try {
      if (!context.mounted) {
        log('Ошибкаsdcsdcsdc');
        return;
      }
      final response = await _dio.get('/daily');
      final data = response.data as Map<String, dynamic>;
      TextDto textDto = TextDto.fromJson(data["textDto"]);
      Navigator.pushNamed(
        context,
        RouteNames.readingScreen,
        arguments: {'textDto': textDto, 'progress': 0.0},
      );
    } catch (e) {
      log("error");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка загрузки текста: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AllTextWidget();
  }
}
