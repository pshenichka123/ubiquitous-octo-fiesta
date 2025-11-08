import 'package:flutter/material.dart';
import './RouteNames.dart';
import '../../features/features.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.mainScreen:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case RouteNames.readingScreen:
        return MaterialPageRoute(
          builder: (_) => const ReadingScreen(), // без аргументов!
          settings: settings, // важно: передаём settings
        );
      default:
        return MaterialPageRoute(builder: (_) => const MainScreen());
    }
  }
}
