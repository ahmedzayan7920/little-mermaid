import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/app_theme.dart';
import 'package:puzzle/screens/call/call_pickup_screen.dart';
import 'package:puzzle/screens/home/home_screen.dart';
import 'package:puzzle/screens/on_boarding/on_boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/auth/login_screen.dart';

late bool isLogin;
late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  isLogin = FirebaseAuth.instance.currentUser != null ? true : false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var id = sharedPreferences.getString("id") ?? "";
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: isLogin
          ? id == FirebaseAuth.instance.currentUser!.uid
              ? const CallPickupScreen(scaffold: HomeScreen())
              : const OnBoardingScreen()
          : const LoginScreen(),
    );
  }
}
