import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './controllers/auth_controler/auth_controller.dart';
import './controllers/theme_controller/theme_controller.dart';
import './router/Router.dart'; // Import RouteNames
import './themes/themes.dart';
import 'controllers/text_controller/text_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => TextController()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp(
            theme: lightTheme, // Светлая тема
            darkTheme: darkTheme, // Тёмная тема
            themeMode: themeController.themeMode,
            initialRoute: RouteNames.splashScreen, // Начальный маршрут
            onGenerateRoute: MyRouter.generateRoute, // Генерация маршрутов
          );
        },
      ),
    );
  }
}
