import 'dart:developer';

import 'package:app/router/Router.dart';
import 'package:app/services/storage_service/my_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../../controllers/text_controller/text_controller.dart';
import './logout_button.dart';
import './CustomDropout.dart';
import '../../../controllers/auth_controler/auth_controller.dart';
import 'package:app/dto/text_dto.dart';

class ReadingWidget extends StatefulWidget {
  @override
  State<ReadingWidget> createState() => _ReadingWidgetState();
}

class _ReadingWidgetState extends State<ReadingWidget> {
  @override
  Widget build(BuildContext context) {
    final textController = Provider.of<TextController>(context, listen: false);
    final _myStorage = MyStorage();
    return Container(
      child: Center(
        child: GestureDetector(
          child: const Text("Портал в почитушки"),
          onTap: () async {
            // Показать индикатор загрузки, если нужно
            if (textController.isLoading) return;

            try {
              // Получить данные перед переходом
              final TextDto textDto = await textController.getDaily();
              final double fontSize = await _myStorage.getFontSize();
              log(textDto.toJson().toString());
              log(fontSize.toString());
              if (!context.mounted) {
                log('Ошибка');
                return;
              }
              Navigator.pushNamed(
                context,
                RouteNames.readingScreen,
                arguments: {'fontSize': fontSize, 'textDto': textDto},
              );
            } catch (e) {
              // Обработать ошибку, например, показать SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка загрузки данных: $e')),
              );
            }
          },
        ),
      ),
    );
  }
}
