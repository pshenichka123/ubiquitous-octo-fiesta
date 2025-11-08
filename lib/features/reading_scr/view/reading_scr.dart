import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../dtos/text_history_item.dart';
import '../../../dtos/text_dto.dart';
import '../widgets/my_text.dart';
import '../widgets/my_title.dart';
import 'package:dio/dio.dart';

class ReadingScreen extends StatefulWidget {
  final Map<String, dynamic>? args;

  const ReadingScreen({super.key, this.args});

  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://77.222.53.147:5000/api',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  double _readPercentage = 0;
  ScrollDirection _lastscrollDirection = ScrollDirection.idle;
  late TextDto _textDto;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    _readPercentage = args["progress"];
    _textDto = args["textDto"];
  }

  Future<void> _onScreenClose(TextDto textData) async {
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
      _dio.post(
        "/readingHistory",
        data: {
          "id": id,
          "textHistoryItem": TextHistoryItem(
            id: textData.id,
            title: textData.title,
            progress: _readPercentage,
            lastReading: DateTime.now(),
          ).toJson(),
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  void _updateReadPercentage() {
    if (_scrollController.position.maxScrollExtent > 0) {
      setState(() {
        _readPercentage =
            (_scrollController.offset /
                _scrollController.position.maxScrollExtent) *
            100;
        _readPercentage = _readPercentage.clamp(0.0, 100.0);
      });
    }
  }

  bool _onNotification(ScrollNotification scrollNotification) {
    if (scrollNotification is ScrollEndNotification) {
      _updateReadPercentage();
    } else if (scrollNotification is ScrollUpdateNotification) {
      final currentDirection = _scrollController.position.userScrollDirection;
      if (currentDirection != _lastscrollDirection &&
          currentDirection != ScrollDirection.idle) {
        _lastscrollDirection = currentDirection;
        _updateReadPercentage();
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          _onScreenClose(_textDto);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              MyTitle(title: _textDto.title),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: _onNotification,
                  child: MyText(
                    text: _textDto.text,
                    scrollController: _scrollController,
                    startPosition: _readPercentage,
                  ),
                ),
              ),
              Text('Прочитано: ${(_readPercentage.toStringAsFixed(1))}%'),
            ],
          ),
        ),
      ),
    );
  }
}
