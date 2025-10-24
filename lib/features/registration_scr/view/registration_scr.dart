import 'package:app/router/Router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/auth_controler/auth_controller.dart';
import '../widgets/auth_action_button.dart';
import '../widgets/auth_fields.dart';
import '../widgets/login_register_buttons.dart';
import '../widgets/theme_switch.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoginMode = true;

  void _handleToggle(bool isFirstSelected) {
    setState(() {
      _isLoginMode = isFirstSelected;
    });
    print('Выбрано: ${isFirstSelected ? "Вход" : "Регистрация"}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AuthController>(
            builder: (context, authController, child) {
              return Column(
                children: [
                  ToggleText(
                    firstText: 'Вход',
                    secondText: 'Регистрация',
                    onToggle: _handleToggle,
                  ),
                  const SizedBox(height: 20),
                  AuthFields(
                    emailController: _emailController,
                    passwordController: _passwordController,
                  ),
                  const SizedBox(height: 20),
                  AuthActionButton(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    isLoginMode: _isLoginMode,
                    isLoading: authController.isLoading,
                    authController: authController, // Передаём authController

                    onError: (error) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error)));
                    },
                  ),
                  const SizedBox(height: 500),
                  const ThemeSwitch(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
