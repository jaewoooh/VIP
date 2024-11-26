import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vip/Game/Lv2/test2.dart';
import 'package:vip/Game/Lv3/wait3.dart';


/// 메인 페이지 위젯
class WaitPage1 extends StatefulWidget {
  const WaitPage1({super.key});

  @override
  State<WaitPage1> createState() => _WaitPageState();
}

/// WaitPage의 상태 관리 클래스
class _WaitPageState extends State<WaitPage1> with TickerProviderStateMixin {
  late AnimationController waveController; // 파동 애니메이션 컨트롤러
  late AnimationController imageController; // 이미지 애니메이션 컨트롤러
  late Animation<double> scaleAnimation; // 이미지 크기 애니메이션
  late Animation<double> fadeAnimation; // 이미지 투명도 애니메이션
  int countdown = 10; // 카운트다운 초기 값
  bool showCountdown = true; // 카운트다운 메시지 표시 여부

  @override
  void initState() {
    super.initState();

    // 파동 애니메이션 컨트롤러 초기화
    waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7), // 파동 애니메이션 주기
    )..repeat(); // 무한 반복

    // 이미지 애니메이션 컨트롤러 초기화
    imageController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 이미지 애니메이션 주기
    )..repeat(reverse: true); // 무한 반복하며 커졌다 줄어듦

    // 크기 애니메이션 정의
    scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: imageController,
        curve: Curves.easeInOut,
      ),
    );

    // 투명도 애니메이션 정의
    fadeAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: imageController,
        curve: Curves.easeInOut,
      ),
    );

    // 카운트다운 시작
    _startCountdown();
  }

  /// Test1Page로 이동하는 메서드
  void _navigateToTest1() {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser; // 현재 로그인된 사용자 가져오기
      if (currentUser != null) {
        final String userId = currentUser.uid; // 로그인된 사용자의 UID 가져오기
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Test1Page(userId: userId), // userId 전달
          ),
        );
      } else {
        // 로그인되지 않은 경우
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인 정보가 없습니다. 다시 로그인해주세요.')),
        );
      }
    } catch (e) {
      // 예외 처리
      debugPrint('Error navigating to Test1Page: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('문제가 발생했습니다. 다시 시도해주세요.')),
      );
    }
  }


  /// 카운트다운 시작 메서드
  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 1) {
        timer.cancel(); // 타이머 종료
        _navigateToTest1(); // Test1Page로 이동
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    waveController.dispose(); // 파동 애니메이션 컨트롤러 해제
    imageController.dispose(); // 이미지 애니메이션 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지 추가
          Positioned.fill(
            child: Image.asset(
              'assets/home3_background.png', // 배경 이미지 경로
              fit: BoxFit.cover, // 화면에 꽉 채우기
            ),
          ),
          // 파동 애니메이션
          Positioned.fill(
            child: AnimatedBuilder(
              animation: waveController, // 파동 애니메이션 컨트롤러 연결
              builder: (context, child) {
                return CustomPaint(
                  painter: MultipleWavesPainter(
                    animationValue: waveController.value, // 파동 애니메이션 값 전달
                  ),
                );
              },
            ),
          ),
          // 애니메이션 효과가 있는 캐릭터 이미지 추가
          Center(
            child: ScaleTransition(
              scale: scaleAnimation, // 크기 애니메이션 적용
              child: FadeTransition(
                opacity: fadeAnimation, // 투명도 애니메이션 적용
                child: Image.asset(
                  'assets/interview_animation.png', // 캐릭터 이미지 경로
                  width: 200, // 기본 이미지 크기
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // 카운트다운 메시지
          if (showCountdown)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 70), // 화면 상단 여백
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E), // 메시지 배경색
                  borderRadius: BorderRadius.circular(20), // 메시지 둥근 테두리
                ),
                child: Text(
                  '$countdown초 뒤에 면접이 시작됩니다!', // 카운트다운 메시지
                  style: const TextStyle(
                    fontSize: 14, // 텍스트 크기
                    color: Colors.white, // 텍스트 색상
                  ),
                ),
              ),
            ),
          // "바로 대답하기" 버튼
          Align(
            alignment: Alignment.bottomCenter, // 버튼 위치: 하단 중앙
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70.0), // 하단 여백
              child: ElevatedButton(
                onPressed: () {
                  _navigateToTest1(); // 버튼 클릭 시 Test1Page로 이동
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 16, 74, 161), // 버튼 배경색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // 버튼 모서리 둥글게
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15), // 버튼 내부 여백
                ),
                child: const Text(
                  '바로 응시하기', // 버튼 텍스트
                  style: TextStyle(
                    fontSize: 16, // 텍스트 크기
                    color: Colors.white, // 텍스트 색상
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
