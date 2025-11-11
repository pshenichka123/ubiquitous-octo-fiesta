import 'package:flutter/foundation.dart';

class ProgressProvider with ChangeNotifier {
  double _progress = 0.0;

  double get progress => _progress;

  void setProgress(double value) {
    if (_progress != value) {
      if (value.toInt() <= 100) {
        _progress = value;
        notifyListeners();
      }
    }
  }
}
