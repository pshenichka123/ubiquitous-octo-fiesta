import 'package:app/services/api_service/api_service.dart';
import 'package:app/services/storage_service/my_storage.dart';

import '../../dto/text_dto.dart';

class TextService {
  ApiService _apiService = ApiService();
  MyStorage _myStorage = MyStorage();
  Future<TextDto> getDaily() async {
    final textDto = await _apiService.daily();
    return textDto;
  }
}
