import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:vip/login_screen.dart';


Future<void> main() async {
  // 스플래시 화면의 시작부분에 widgetBinding 을 설정 함으로써, 언제 스플래시 화면을 끌지 Controll 할수 있다
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // 스플래시 화면 보여줘라. (preserve)
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 초기화 작업
  await Future.delayed(const Duration(seconds: 2));

  // 스플래시 화면 제거
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}


// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner:false,
      home: LoginScreen(),
    );
  }
}