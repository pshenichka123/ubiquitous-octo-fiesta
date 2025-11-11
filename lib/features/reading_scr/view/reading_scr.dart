import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:second_try/api/my_dio.dart';
import 'package:second_try/features/reading_scr/widgets/end_reading_button.dart';
import 'package:second_try/features/reading_scr/widgets/my_scroll_view.dart';
import 'package:second_try/features/reading_scr/widgets/progress_provider.dart';
import '../../../dtos/text_history_item.dart';
import '../../../dtos/text_dto.dart';
import '../widgets/my_text.dart';
import '../widgets/my_title.dart';
import 'package:dio/dio.dart';
import '../widgets/progres_text.dart';
import '../widgets/vertical_progress_slider.dart';

class ReadingScreen extends StatefulWidget {
  final double progress;
  final TextDto textDto;
  final double fontSize;
  const ReadingScreen({
    super.key,
    required this.textDto,
    required this.fontSize,
    this.progress = 0,
  });

  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen>
    with WidgetsBindingObserver {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final Dio _dio = MyDio.instance();
  final ProgressProvider progress = ProgressProvider();
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    progress.setProgress(widget.progress);
  }

  Future<void> _onScreenClose(TextDto textData) async {
    try {
      var idStr = await _storage.read(key: 'id');
      int id;
      if (idStr == null) {
        final response = await _dio.get("/getId");
        final data = response.data as Map<String, dynamic>;
        idStr = data['id'].toString();
        await _storage.write(key: 'id', value: idStr);
      }

      id = int.parse(idStr);
      _dio.post(
        "/readingHistory",
        data: {
          "id": id,
          "textHistoryItem": TextHistoryItem(
            id: textData.id,
            title: textData.title,
            progress: progress.progress,
            lastReading: DateTime.now(),
          ).toJson(),
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);
    return ChangeNotifierProvider.value(
      value: progress,
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          if (didPop) {
            _onScreenClose(widget.textDto);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: MyScrollView(
                        scrollController: controller,
                        child: Column(
                          children: [
                            MyTitle(title: widget.textDto.title),
                            MyText(
                              text: widget.textDto.text,
                              fontSize: widget.fontSize,
                            ),
                            EndReadingButton(),
                          ],
                        ),
                      ),
                    ),
                    ProgressText(),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 60,
                  bottom: 60,
                  child: VerticalProgressSlider(
                    onSlide: () {
                      controller.jumpTo(
                        controller.position.maxScrollExtent *
                            progress.progress /
                            100,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
