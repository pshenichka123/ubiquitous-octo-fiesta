import 'package:flutter/material.dart';
import '../../../controllers/theme_controller/theme_controller.dart';
import 'package:provider/provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    return Column(
      children: [
        Switch(
          value: themeController.isDark,
          onChanged: themeController.toggleTheme,
          thumbColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return Colors.grey.shade600;
            }
            return Colors.white;
          }),
          trackColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return Colors.grey.shade300;
            }
            return Colors.grey.shade800;
          }),
        ),
        Text(
          themeController.isDark ? 'Тёмная тема' : 'Светлая тема',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
