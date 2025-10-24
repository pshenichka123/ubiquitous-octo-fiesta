import 'dart:convert';

class UserDto {
  late String email = '';
  late String password = '';
  late String nickname = '';

  late bool isActivated = false;

  UserDto(this.email, this.password, this.nickname, this.isActivated);
  UserDto.auth({required this.email, required this.password});

  UserDto.empty();

  // Сериализация в JSON
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'nickname': nickname,

    'isActivated': isActivated,
  };

  // Десериализация из JSON
  factory UserDto.fromJson(Map<String, dynamic> json) {
    if (json['email'] == null || json['email'].isEmpty) {
      throw FormatException('Email is required');
    }
    return UserDto(
      json['email'] as String,
      json['password'] as String? ?? '',
      json['nickname'] as String? ?? '',
      json['isActivated'] as bool? ?? false,
    );
  }

  // Строковое представление для хранения
  String toJsonString() => jsonEncode(toJson());

  // Создание объекта из строки JSON
  static UserDto fromJsonString(String jsonString) =>
      UserDto.fromJson(jsonDecode(jsonString));
}
