class TextHistoryItem {
  late int id;
  late String title;
  late DateTime lastReading;
  late double progress;

  TextHistoryItem({
    required this.id,
    required this.title,
    required this.lastReading,
    required this.progress,
  });

  // Конструктор для создания объекта из JSON
  factory TextHistoryItem.fromJson(Map<String, dynamic> json) {
    return TextHistoryItem(
      id: int.parse(json['id']),
      title: json['title'] as String,
      lastReading: DateTime.parse(json['lastReading'] as String),
      progress: (json['progress'] as num).toDouble(),
    );
  }

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastReading': lastReading.toString(),
      'progress': progress,
    };
  }
}
