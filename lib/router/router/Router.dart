import 'package:flutter/material.dart';
import 'package:second_try/dtos/text_dto.dart';
import './RouteNames.dart';
import '../../features/features.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.mainScreen:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case RouteNames.readingScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final TextDto textDto = args['textDto'] as TextDto;
        final double progress = args['progress'] as double;
        final double fonstSize = args['fontSize'] as double;
        return MaterialPageRoute(
          builder: (_) => ReadingScreen(
            textDto: textDto,
            progress: progress,
            fontSize: fonstSize,
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(builder: (_) => const MainScreen());
    }
  }
}
