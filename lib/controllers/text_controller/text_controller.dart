import 'package:app/services/text_service/text_service.dart';
import 'package:flutter/material.dart';
import '../../services/api_service/api_service.dart';
import '../../services/storage_service/my_storage.dart';
import 'package:app/dto/text_dto.dart';

class TextController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final MyStorage _myStorage = MyStorage();
  final TextService _textService = TextService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<TextDto> getDaily() async {
    final textDto = await _textService.getDaily();
    return textDto;
  }
}
