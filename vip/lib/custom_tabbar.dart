import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart'; // motion_tab_bar_v2 패키지에서 MotionTabBar 가져오기
import 'package:motion_tab_bar_v2/motion-tab-controller.dart'; // MotionTabBarController 가져오기 --> 커스터마이징 하려면 이게 필수.

// CustomTabBar 위젯 정의
class CustomTabBar extends StatelessWidget {
  // MotionTabBarController를 통해 탭바 상태를 관리
  final MotionTabBarController tabController;

  // 생성자 - CustomTabBar를 호출할 때 tabController를 필수로 전달받음
  const CustomTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return MotionTabBar(
      // MotionTabBar의 컨트롤러 설정 (탭 변경 상태를 관리)
      controller: tabController,
      
      // 처음 선택될 탭 설정
      initialSelectedTab: "Home",

      // 탭바의 각 탭에 들어갈 텍스트 정의
      labels: const [
        "Study Room", // 첫 번째 탭 (왼쪽)
        "Home",          // 두 번째 탭 (중앙, 텍스트 없음)
        "My Page"    // 세 번째 탭 (오른쪽)
      ],

      // 각 탭의 아이콘 정의
      icons: const [
        Icons.psychology_alt_outlined, // 첫 번째 탭 아이콘
        Icons.rocket_launch_rounded,     // 두 번째 탭 아이콘 (중앙)
        Icons.person_outline        // 세 번째 탭 아이콘
      ],

      // 각 탭에 대한 뱃지 설정 (여기서는 모두 사용하지 않음)
      badges: const [null, null, null],

      // 탭 아이콘의 기본 색상 (선택되지 않았을 때)
      tabIconColor: Colors.grey,

      // 탭 아이콘의 선택된 색상
      tabSelectedColor: const Color(0xff5500AA),

      // 탭 아이콘의 기본 크기
      tabIconSize: 35.0,

      // 탭 아이콘의 선택된 크기
      tabIconSelectedSize: 35.0,

      // 탭바의 전체 배경 색상
      tabBarColor: Colors.white,

      // 각 탭의 크기 (높이)
      tabSize: 50,

      // 탭바의 높이
      tabBarHeight: 55,

      // 탭의 텍스트 스타일 정의
      textStyle: const TextStyle(
        fontSize: 13, // 텍스트 크기
        color: Colors.black, // 텍스트 색상
        fontWeight: FontWeight.bold, // 텍스트 굵기
      ),

      // 탭 변경 시 호출되는 콜백 함수
      onTabItemSelected: (int index) {
        // MotionTabBarController의 인덱스를 업데이트
        tabController.index = index;
      },
    );
  }
}
