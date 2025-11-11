import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:second_try/features/reading_scr/widgets/progress_provider.dart';

class MyScrollView extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  const MyScrollView({
    super.key,
    required this.child,
    required this.scrollController,
  });

  @override
  State<StatefulWidget> createState() {
    return MySrollViewState();
  }
}

class MySrollViewState extends State<MyScrollView> {
  void _updateProgressFromScroll() {
    late final ProgressProvider progress = context.read<ProgressProvider>();
    final newProgress =
        widget.scrollController.offset /
        widget.scrollController.position.maxScrollExtent *
        100;
    progress.setProgress(newProgress);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      late final ProgressProvider progress = context.read<ProgressProvider>();
      final maxScroll = widget.scrollController.position.maxScrollExtent;
      final targetPosition = (maxScroll * progress.progress / 100);
      widget.scrollController.jumpTo(targetPosition);
      widget.scrollController.addListener(_updateProgressFromScroll);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: widget.child,
    );
  }
}
