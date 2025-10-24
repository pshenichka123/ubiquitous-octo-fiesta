import 'package:flutter/material.dart';
import 'package:app/router/router/RouteNames.dart';
import 'package:app/features/features.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.welcomeScreen:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case RouteNames.registrationScreen:
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case RouteNames.mainScreen:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case RouteNames.profileScreen:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case RouteNames.readingScreen:
        {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => ReadingScreen(args: args),
          );
        }
      case RouteNames.readingHistoryScreen:
        return MaterialPageRoute(builder: (_) => const ReadingHistoryScreen());

      case RouteNames.settingsScreen:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case RouteNames.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
    }
  }
}
