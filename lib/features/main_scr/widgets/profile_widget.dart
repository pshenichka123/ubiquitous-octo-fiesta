import 'package:flutter/material.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: FittedBox(fit: BoxFit.scaleDown),
            ),
            SizedBox(width: 40),
          ],
        ),
        TextField(
          controller: _nicknameFieldController,
          decoration: InputDecoration(labelText: "Введите ник"),
        ),
        TextButton(
          onPressed: () async {},
          child: Text('Сменить', style: TextStyle(fontSize: 30)),
        ),
        SizedBox(height: 50, width: 50),
      ],
    );
  }
}
