// lib/presentation/providers/auth_provider.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../services/api_service/api_service.dart';
import '../../dto/user_dto.dart';
import '../../services/storage_service/my_storage.dart';

class AuthController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final MyStorage _myStorage = MyStorage();
  bool _isLoading = false;
  UserDto? _user;

  AuthController() {
    // Инициализируем состояние пользователя при создании контроллера
    _loadUser();
  }

  bool get isLoading => _isLoading;
  UserDto? get user => _user;
  bool get isAuthenticated => _user != null;

  // Загружаем данные пользователя из хранилища при инициализации
  Future<void> _loadUser() async {
    try {
      _user = await _myStorage.getUser();
      notifyListeners();
    } catch (e) {
      _user = null; // Пользователь не авторизован
    }
  }

  Future<void> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final userDto = await _apiService.registration(email, password);
      _user = userDto;
      await _myStorage.writeUser(userDto);
      notifyListeners();
    } catch (e) {
      log('Registration error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final map = await _apiService.login(email, password);
      _user = map['userDto'] as UserDto;
      await _myStorage.writeUser(map['userDto']);
      await _myStorage.writeRefreshToken(map['refreshToken']);
      await _myStorage.writeAccessToken(map['accessToken']);
      notifyListeners();
    } catch (e) {
      log('Login error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      final refreshToken = await _myStorage.getRefreshToken();
      await _apiService.logout(refreshToken);
      await _myStorage.clearUser();
      await _myStorage.clearTokens();
      _user = null;
      notifyListeners();
    } catch (e) {
      log('Logout error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> refresh() async {
    _isLoading = true;
    notifyListeners();
    try {
      final refreshToken = await _myStorage.getRefreshToken();
      final map = await _apiService.refresh(refreshToken);
      _user = map['userDto'] as UserDto;
      await _myStorage.writeUser(map['userDto']);
      await _myStorage.writeRefreshToken(map['refreshToken']);
      await _myStorage.writeAccessToken(map['accessToken']);
      notifyListeners();
      return true;
    } catch (e) {
      log('Refresh error: $e');
      _user = null; // Сбрасываем пользователя при ошибке
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
