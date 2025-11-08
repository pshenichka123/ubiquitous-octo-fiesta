import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './router/Router.dart';
import './theme_controller/theme_controller.dart';
import './themes/themes.dart';

void main() async {

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<StatefulWidget> createState() => MyAppState();
}
 class MyAppState extends State<MyApp>
 {


   @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeController())],
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeController.themeMode,
            initialRoute: RouteNames.mainScreen,
            onGenerateRoute: MyRouter.generateRoute,
          );
        },
      ),
    );
  }
}
