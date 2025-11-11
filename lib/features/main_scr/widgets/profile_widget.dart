import 'package:flutter/material.dart';
import 'package:second_try/features/main_scr/widgets/image_widget.dart';

import 'nickname_widget.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget>
    with WidgetsBindingObserver {
  final TextEditingController _nicknameFieldController =
      TextEditingController();
  bool isWidgetActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        ImageWidget(),
        Expanded(
          child: Align(alignment: Alignment.topCenter, child: NicknameWidget()),
        ),
      ],
    );
  }
}
