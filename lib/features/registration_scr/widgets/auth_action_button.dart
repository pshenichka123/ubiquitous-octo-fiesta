import 'package:flutter/material.dart';
import '../../../controllers/auth_controler/auth_controller.dart';
import '../../../router/router/RouteNames.dart';

class AuthActionButton extends StatelessWidget {
  final bool isLoginMode;
  final bool isLoading;
  final TextEditingController emailController; // Контроллер вместо строки
  final TextEditingController passwordController; // Контроллер вместо строки
  final AuthController authController;
  final Function(String) onError;

  const AuthActionButton({
    super.key,
    required this.isLoginMode,
    required this.isLoading,
    required this.emailController,
    required this.passwordController,
    required this.authController,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : GestureDetector(
            onTap: () async {
              // Получаем АКТУАЛЬНЫЕ значения из контроллеров
              final email = emailController.text.trim();
              final password = passwordController.text.trim();

              // Простая валидация
              if (email.isEmpty) {
                onError('Email cannot be empty');
                return;
              }
              if (password.isEmpty) {
                onError('Password cannot be empty');
                return;
              }

              try {
                if (isLoginMode) {
                  await authController.login(email, password);
                  Navigator.pushNamed(context, RouteNames.mainScreen);
                } else {
                  await authController.register(email, password);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Регистрация прошла успешно, перейдите по ссылке, отправленной на почту',
                      ),
                    ),
                  );
                }
              } catch (e) {
                onError('${isLoginMode ? 'Вход' : 'Регистрация'} failed: $e');
              }
            },
            child: Text(
              isLoginMode ? 'Вход' : 'Регистрация',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          );
  }
}
