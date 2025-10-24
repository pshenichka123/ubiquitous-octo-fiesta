import 'dart:convert';

class TextDto {
  late String title = '';
  late String text = '';
  late String source = '';

  late int ratesum = 0;
  late int ratecount = 0;
  TextDto(this.title, this.text, this.source, this.ratecount, this.ratesum);

  TextDto.empty();

  // Сериализация в JSON
  Map<String, dynamic> toJson() => {
    'title': title,
    'text': text,
    'source': source,

    'ratesum': ratesum,
    'ratecount': ratecount,
  };

  // Десериализация из JSON
  factory TextDto.fromJson(Map<String, dynamic> json) {
    return TextDto(
      json['title'] as String,
      json['text'] as String? ?? '',
      json['source'] as String? ?? '',
      json['ratecount'] as int? ?? 0,
      json['ratesum'] as int? ?? 0,
    );
  }

  // Строковое представление для хранения
  String toJsonString() => jsonEncode(toJson());

  // Создание объекта из строки JSON
  static TextDto fromJsonString(String jsonString) =>
      TextDto.fromJson(jsonDecode(jsonString));
}
