import 'dart:convert';
import 'package:sec_try/dtos/text_list_item.dart';

class TextListDto
{
  late List<TextListItem> items;

  TextListDto({required this.items});

  // Конструктор для создания объекта из JSON
  factory TextListDto.fromJson(Map<String, dynamic>? json) {
    if (json == null || json['items'] == null) {
      return TextListDto(items: []);
    }

    final List<dynamic> itemsJson = json['items'] as List<dynamic>;
    final items = itemsJson
        .map(
          (itemJson) =>
          TextListItem.fromJson(itemJson as Map<String, dynamic>),
    )
        .toList();

    return TextListDto(items: items);
  }
  String toJson() {
    final List<Map<String, dynamic>> jsonList = items
        .map((item) => item.toJson())
        .toList();
    return jsonEncode(jsonList);
  }

  factory TextListDto.empty() {
    return TextListDto(items: []);
  }
}