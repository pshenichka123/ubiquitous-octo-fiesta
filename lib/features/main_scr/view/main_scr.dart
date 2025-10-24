import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/settings_widget.dart';
import '../widgets/profile_widget.dart';
import '../widgets/reading_widget.dart';
import '../widgets/reading_history_widget.dart';
import '../../../controllers/auth_controler/auth_controller.dart';
import '../widgets/CustomDropout.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int? _expandedIndex;
  final double collapsedHeight = 100.0;

  final List<Widget> titleList = [
    SizedBox(
      height: 100,
      child: Text('Профиль', style: TextStyle(fontSize: 50)),
    ),
    SizedBox(
      height: 100,
      child: Text('Настройки', style: TextStyle(fontSize: 50)),
    ),
    SizedBox(
      height: 100,
      child: Text('Читать', style: TextStyle(fontSize: 50)),
    ),
    SizedBox(
      height: 100,
      child: Text('История чтения', style: TextStyle(fontSize: 50)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> contentWidgets = [
      ProfileWidget(context),
      SettingsWidget(),
      ReadingWidget(),
      ReadingHistoryWidget(context),
    ];
    final double availableHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        Provider.value(value: this),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(titleList.length, (index) {
                return CustomDropdown(
                  titleWidget: titleList[index],
                  contentWidget: contentWidgets[index],
                  isExpanded: _expandedIndex == index,
                  availableHeight:
                      availableHeight -
                      (titleList.length * (collapsedHeight + 20)),
                  collapsedHeight: collapsedHeight,
                  onTap: () {
                    setState(() {
                      _expandedIndex = _expandedIndex == index ? null : index;
                    });
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
