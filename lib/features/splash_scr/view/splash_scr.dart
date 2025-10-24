import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/auth_controler/auth_controller.dart';
import '../../../router/Router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Выполняем операции после завершения построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performStartupOperations(context);
    });
  }

  Future<void> _performStartupOperations(BuildContext context) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    try {
      // Проверка авторизации
      bool isAuthenticated = await authController.refresh();
      // Перенаправление на основе результата
      Navigator.pushReplacementNamed(
        context,
        isAuthenticated ? RouteNames.mainScreen : RouteNames.registrationScreen,
      );
    } catch (e) {
      // В случае ошибки показываем сообщение и перенаправляем на экран логина
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      Navigator.pushReplacementNamed(context, RouteNames.registrationScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
