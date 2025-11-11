import 'package:flutter/material.dart';
import '../widgets/settings_widget.dart';
import '../widgets/profile_widget.dart';
import '../widgets/reading_widget.dart';
import '../widgets/reading_history_widget.dart';
import '../widgets/custom_dropout.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int? _expandedIndex;
  final double collapsedHeight = 100.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
      ProfileWidget(),
      SettingsWidget(),
      ReadingWidget(),
      ReadingHistoryWidget(),
    ];
    final double availableHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
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
