import 'package:dio/dio.dart';

class MyDio {
  static late final Dio _dio;
  static bool _inited = false;

  static Dio instance() {
    if (!_inited) {
      _dio = Dio(
        BaseOptions(
          baseUrl: 'http://77.222.53.147:5000/api',
          connectTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ),
      );
      _inited = true;
    }
    return _dio;
  }
}
