import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/auth_controler/auth_controller.dart';
import '../../../router/Router.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return FloatingActionButton(
          onPressed: () async {
            try {
              await authController.logout();
              Navigator.pushNamed(context, RouteNames.registrationScreen);
            } catch (e) {}
          },
          child: const Text('logout'),
        );
      },
    );
  }
}
