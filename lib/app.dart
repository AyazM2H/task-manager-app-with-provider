import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/ui/controllers/state_manager.dart';
import 'package:taskmanager/ui/screens/login_screen.dart';
import 'package:taskmanager/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:taskmanager/ui/screens/splash_screen.dart';

class TaskManager extends StatelessWidget {
  const TaskManager({super.key});

  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigator,
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          )
        ),
        colorSchemeSeed: Colors.green,
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              fixedSize: Size.fromWidth(double.maxFinite),
              padding: EdgeInsets.symmetric(vertical: 12)
          ),
        )
      ),
      initialRoute: SplashScreen.name,
      routes: {
        SplashScreen.name: (_)=> SplashScreen(),
        LoginScreen.name: (_)=> LoginScreen(),
        MainNavBarHolderScreen.name: (_)=> MainNavBarHolderScreen()
      },
      title: 'Task Manager',
      home: SplashScreen(),
    );
  }
}
