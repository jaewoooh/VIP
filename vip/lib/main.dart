import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'custom_tabbar.dart';
import 'Home/home.dart';
import 'StudyRoom/study_room.dart';
import 'MyPage/my_page.dart';

Future<void> main() async {
  // 스플래시 화면 유지 설정
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 초기화 작업
  await Future.delayed(const Duration(seconds: 2));

  // 스플래시 화면 제거
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      home: MainNavigation(),     // MainNavigation 위젯을 홈으로 설정
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with TickerProviderStateMixin {
  // MotionTabBarController 초기화
  late MotionTabBarController _tabController;

  @override
  void initState() {
    super.initState();
    // MotionTabBarController 생성 및 초기화 (탭 수: 3)
    _tabController = MotionTabBarController(
      initialIndex: 1, // 초기 선택 탭 (Home)
      vsync: this,
      length: 3,
    );
  }

  @override
  void dispose() {
    // MotionTabBarController 메모리 해제
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController, // MotionTabBarController 연결
        physics: const NeverScrollableScrollPhysics(), // 스와이프 비활성화
        children: const [
          StudyRoomScreen(), // 첫 번째 탭: StudyRoom 페이지
          HomeScreen(),      // 두 번째 탭: Home 페이지
          MyPageScreen(),    // 세 번째 탭: MyPage 페이지
        ],
      ),
      bottomNavigationBar: CustomTabBar(tabController: _tabController), // CustomTabBar 사용
    );
  }
}