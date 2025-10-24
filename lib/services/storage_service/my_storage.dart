import 'dart:ffi';

import '../../dto/user_dto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './keys.dart';

class MyStorage {
  static final MyStorage _instance = MyStorage._internal();
  factory MyStorage() => _instance;
  MyStorage._internal();

  final _storage = const FlutterSecureStorage();
  Future<UserDto> writeUser(UserDto userDto) async {
    await _storage.write(key: Keys.user, value: userDto.toJsonString());
    return userDto;
  }

  Future<String> getRefreshToken() async {
    final String? refreshToken = await _storage.read(key: Keys.refreshToken);
    if (refreshToken == null) {
      throw Error();
    }
    return refreshToken;
  }

  Future<bool> saveFontSize(double val) async {
    try {
      await _storage.write(key: Keys.fontSize, value: val.toString());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<double> getFontSize() async {
    try {
      final String? fontSizeStr = await _storage.read(key: Keys.fontSize);
      if (fontSizeStr == null) {
        return 16.0; // Значение по умолчанию
      }
      final double fontSize = double.tryParse(fontSizeStr) ?? 16.0;
      return fontSize > 0
          ? fontSize
          : 16.0; // Проверяем, что размер шрифта положительный
    } catch (e) {
      return 16.0; // Значение по умолчанию при ошибке
    }
  }

  Future<String> getAccessToken() async {
    final String? accessToken = await _storage.read(key: Keys.accessToken);
    if (accessToken == null) {
      throw Error();
    }
    return accessToken;
  }

  Future<String> writeRefreshToken(refreshToken) async {
    await _storage.write(key: Keys.refreshToken, value: refreshToken);
    return refreshToken;
  }

  Future<String> writeAccessToken(accessToken) async {
    await _storage.write(key: Keys.accessToken, value: accessToken);
    return accessToken;
  }

  Future<void> clearUser() async {
    await _storage.delete(key: Keys.user);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: Keys.accessToken);
    await _storage.delete(key: Keys.refreshToken);
  }

  Future<UserDto> getUser() async {
    final String? jsonStrUser = await _storage.read(key: Keys.user);
    if (jsonStrUser == null) {
      throw Error();
    }
    return UserDto.fromJsonString(jsonStrUser);
  }
}
