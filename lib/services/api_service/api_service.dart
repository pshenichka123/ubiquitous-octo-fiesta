import 'dart:async';
import 'dart:developer';
import 'package:app/dto/text_dto.dart';
import 'package:dio/dio.dart';
import 'package:synchronized/synchronized.dart';
import '../../dto/user_dto.dart';
import '../storage_service/my_storage.dart';

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  final _lock = Lock(); // Для синхронизации обновления токенов
  final MyStorage _storage = MyStorage(); // Singleton хранилище

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.0.106:5000/api',
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          if (e.response?.statusCode == 401) {
            try {
              return await _lock.synchronized(() async {
                final refreshToken = await _storage.getRefreshToken();
                final result = await refresh(refreshToken);
                final newAccessToken = result['accessToken'] as String;
                final newRefreshToken = result['refreshToken'] as String;
                await _storage.writeRefreshToken(newRefreshToken);
                await _storage.writeAccessToken(newAccessToken);
                final options = e.requestOptions;
                final retryResponse = await _dio.fetch(options);
                return handler.resolve(retryResponse);
              });
            } catch (refreshError) {
              return handler.reject(
                DioException(
                  requestOptions: e.requestOptions,
                  error: UnauthorizedException(
                    'Ошибка обновления токена: $refreshError',
                  ),
                ),
              );
            }
          }
          // Для других бросаем ошибку дальше
          return handler.next(e);
        },
      ),
    );
  }

  Future<UserDto> registration(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email и пароль не могут быть пустыми');
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw Exception('Неверный формат email');
    }
    try {
      final response = await _dio.post(
        '/registration',
        data: {'email': email, 'password': password},
      );
      log('Registration response: ${response.data}');
      return UserDto.fromJson(response.data['user']);
    } catch (e) {
      if (e is DioException) {
        throw Exception(
          'Ошибка регистрации: ${e.response?.statusCode} ${e.message}',
        );
      }
      throw Exception('Непредвиденная ошибка: $e');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email и пароль не могут быть пустыми');
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw Exception('Неверный формат email');
    }
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      log('Login response: ${response.data}');

      final data = response.data as Map<String, dynamic>;
      final userDto = UserDto.fromJson(data['user']);
      final refreshToken = data['refreshToken'] as String;
      final accessToken = data['accessToken'] as String;

      // Сохраняем токены и данные пользователя
      await _storage.writeUser(userDto);
      await _storage.writeRefreshToken(refreshToken);
      await _storage.writeAccessToken(accessToken);

      return {
        'userDto': userDto,
        'refreshToken': refreshToken,
        'accessToken': accessToken,
      };
    } catch (e) {
      if (e is DioException) {
        throw Exception('Ошибка входа: ${e.response?.statusCode} ${e.message}');
      }
      throw Exception('Непредвиденная ошибка: $e');
    }
  }

  Future<Map<String, dynamic>> refresh(String refreshToken) async {
    if (refreshToken.isEmpty) {
      throw Exception('Refresh token не может быть пустым');
    }
    try {
      final response = await _dio.post(
        '/refresh',
        data: {'refreshToken': refreshToken},
      );
      log('Refresh response: ${response.data}');

      final data = response.data as Map<String, dynamic>;
      final userDto = UserDto.fromJson(data['user']);
      final newRefreshToken = data['refreshToken'] as String;
      final newAccessToken = data['accessToken'] as String;

      await _storage.writeUser(userDto);
      await _storage.writeRefreshToken(newRefreshToken);
      await _storage.writeAccessToken(newAccessToken);

      return {
        'userDto': userDto,
        'refreshToken': newRefreshToken,
        'accessToken': newAccessToken,
      };
    } catch (e) {
      if (e is DioException) {
        throw Exception(
          'Ошибка обновления токена: ${e.response?.statusCode} ${e.message}',
        );
      }
      throw Exception('Непредвиденная ошибка: $e');
    }
  }

  Future<TextDto> daily() async {
    try {
      final accessToken = await _storage.getAccessToken();
      log('api');
      final response = await _dio.post(
        '/daily',
        data: {'accessToken': accessToken},
      );
      final TextDto textDto = TextDto.fromJson(response.data);
      return textDto;
    } catch (e) {
      log(e.toString());
      return TextDto.empty();
    }
  }

  Future<void> logout(String refreshToken) async {
    if (refreshToken.isEmpty) {
      throw Exception('Refresh token не может быть пустым');
    }
    try {
      await _dio.post('/logout', data: {'refreshToken': refreshToken});
      await _storage.clearTokens();
      await _storage.clearUser();
    } catch (e) {
      if (e is DioException) {
        throw Exception(
          'Ошибка выхода: ${e.response?.statusCode} ${e.message}',
        );
      }
      throw Exception('Непредвиденная ошибка: $e');
    }
  }
}
