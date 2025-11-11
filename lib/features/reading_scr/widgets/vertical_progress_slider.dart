import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_try/features/reading_scr/widgets/progress_provider.dart';

class VerticalProgressSlider extends StatelessWidget {
  final Function onSlide;
  const VerticalProgressSlider({super.key, required this.onSlide});
  @override
  Widget build(BuildContext context) {
    final ProgressProvider progress = context.watch<ProgressProvider>();

    return RotatedBox(
      quarterTurns: 1,
      child: SizedBox(
        width: 220,
        child: SliderTheme(
          data: SliderThemeData(
            trackHeight: 7,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            activeTrackColor: Colors.grey[600],
            inactiveTrackColor: Colors.grey[600],
            thumbColor: Colors.white30,
            overlayColor: Colors.transparent,
          ),
          child: Slider(
            min: 0,
            max: 100,
            value: (progress.progress),
            onChanged: (value) {
              onSlide();
              progress.setProgress(value);
            },
          ),
        ),
      ),
    );
  }
}
