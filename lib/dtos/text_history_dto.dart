import 'dart:math';
import 'dart:convert';
import '../dtos/text_history_item.dart';

class TextHistoryDto {
  late List<TextHistoryItem> items;

  TextHistoryDto({required this.items});

  // Конструктор для создания объекта из JSON
  factory TextHistoryDto.fromJson(Map<String, dynamic>? json) {
    if (json == null || json['items'] == null) {
      return TextHistoryDto(items: []);
    }

    final List<dynamic> itemsJson = json['items'] as List<dynamic>;
    final items = itemsJson
        .map(
          (itemJson) =>
              TextHistoryItem.fromJson(itemJson as Map<String, dynamic>),
        )
        .toList();

    return TextHistoryDto(items: items);
  }
  String toJson() {
    final List<Map<String, dynamic>> jsonList = items
        .map((item) => item.toJson())
        .toList();
    return jsonEncode(jsonList);
  }

  void sortByTime() {
    items.sort((a, b) => b.lastReading.compareTo(a.lastReading));
  }

  factory TextHistoryDto.empty() {
    return TextHistoryDto(items: []);
  }
}
