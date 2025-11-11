import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_try/features/reading_scr/widgets/progress_provider.dart';

class ProgressText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProgressProvider progress = context.watch<ProgressProvider>();
    return Text('Прочитано: ${(progress.progress.toStringAsFixed(1))}%');
  }
}
