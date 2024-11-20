import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'Login&Register/login.dart';
import 'custom_tabbar.dart';
import 'Home/home.dart';
import 'StudyRoom/study_room.dart';
import 'MyPage/my_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:vip/main_navigation.dart';

Future<void> main() async { 
  // 스플래시 화면 유지 설정
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 초기화 작업
  await Future.delayed(const Duration(seconds: 2));

  // 스플래시 화면 제거
  FlutterNativeSplash.remove();
  runApp(const Login());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainNavigation(), // MainNavigation 설정
    );
  }
}