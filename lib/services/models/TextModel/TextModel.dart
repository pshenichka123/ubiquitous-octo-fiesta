import 'package:json_annotation/json_annotation.dart';
part 'TextModel.g.dart';

@JsonSerializable()
class TextModel {
  final int id; //
  final String title;
  final String textt;
  final String source;
  TextModel(
    this.source, {
    required this.id,
    required this.title,
    required this.textt,
  });
  factory TextModel.fromJson(Map<String, dynamic> json) =>
      _$TextModelFromJson(json);
  Map<String, dynamic> toJson() => _$TextModelToJson(this);
}
