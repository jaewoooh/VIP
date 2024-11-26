import 'package:flutter/material.dart';
import 'package:vip/Game/Setting/game_setting1.dart';

import 'Lv1/level1.dart';

class GameMain1 extends StatefulWidget {
  const GameMain1({super.key});

  @override
  GameMain1State createState() => GameMain1State();
}

class GameMain1State extends State<GameMain1> {
  int currentStep = 1; // 현재 활성화된 단계

  // 단계별 프로필 데이터
  final List<Map<String, dynamic>> characterData = [
    {
      'name': 'John Kenneth',
      'department': '부서 : 인사팀',
      'image': 'assets/character(1).png',
    },
    {
      'name': ['Ethan', 'Lily'],
      'department': ['부서 : 사용자와 다른 부서', '부서 : 사용자가 선택한 부서'],
      'image': ['assets/character(2).png', 'assets/character(3).png'],
    },
    {
      'name': 'Sofia Valentina',
      'department': '부서 : 사용자 담당 부서',
      'image': 'assets/character(4).png',
    },
    {
      'name': 'Lucas Alejan',
      'department': '부서 : 사용자 담당 부서',
      'image': 'assets/character(5).png',
    },
  ];

  // 클릭 애니메이션 관련 변수
  double _stepSize = 70; // 원의 크기
  double _shadowBlurRadius = 10; // 그림자의 흐림 정도
  Offset _shadowOffset = const Offset(4, 4); // 그림자의 위치

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF2B2B2B),
    body: Stack(
      children: [
        Column(
          children: [
            // 상단 회색 프로필 섹션
            _buildProfileSection(),
            // 단계별 UI (역순으로 배치)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // 상단 정렬
                  children: _buildStepListWithCustomSpacing(),
                ),
              ),
            ),
            const SizedBox(height: 25), // 하단 여백 추가
          ],
        ),
        // 왼쪽 하단 고정 버튼
        Positioned(
          bottom: 20,
          left: 20,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 21, 21, 21), // 버튼 배경 색상
              foregroundColor: Colors.white, // 버튼 텍스트 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // 버튼 모서리 둥글게
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              // 버튼 클릭 시 동작
             Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Home2Screen()),
             );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min, // 아이콘과 텍스트를 버튼 크기에 맞춤
              children: [
                Icon(
                  Icons.settings, // 세팅 아이콘
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                SizedBox(width: 8), // 아이콘과 텍스트 간격
                Text(
                  'Setting', // 버튼 텍스트
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}



  List<Widget> _buildStepListWithCustomSpacing() {
    List<Widget> steps = [];
    for (int i = 4; i >= 1; i--) {
      steps.add(
        Column(
          children: [
            _buildLockStep(
              isLocked: currentStep < i,
              stepNumber: '$i',
              onTap: () => _onStepTap(i),
            ),
            if (i > 1) // 마지막 원 아래는 선을 추가하지 않음
              _buildVerticalLineWithSpacing(),
          ],
        ),
      );
    }
    return steps;
  }

  // 선과 원 사이의 간격을 조절
  Widget _buildVerticalLineWithSpacing() {
    return Column(
      children: [
        const SizedBox(height: 0), // 선 위 간격
        Container(
          width: 3,
          height: 40, // 선의 높이
          color: Colors.white24,
        ),
        const SizedBox(height: 0), // 선 아래 간격
      ],
    );
  }

// 프로필 섹션 위젯
Widget _buildProfileSection() {
  if (currentStep == 2) {
    // 2단계일 때 두 명의 캐릭터 표시
    return Container(
      height: 230,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color(0xFF6A6A6A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54, // 그림자 색상
            offset: Offset(4, 4), // 그림자의 위치
            blurRadius: 10, // 그림자 흐림 정도
            spreadRadius: 2, // 그림자 확장
          ),
          BoxShadow(
            color: Colors.white24, // 하이라이트 효과
            offset: Offset(-4, -4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // 사진 간 간격 유지
        children: [
          // 첫 번째 캐릭터
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 45, right: 10),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: const Color.fromARGB(255, 187, 205, 235),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38, // 그림자 색상
                        offset: Offset(4, 4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      characterData[currentStep - 1]['image'][0],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 9),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  characterData[currentStep - 1]['name'][0],
                  style: _nameTextStyle1().copyWith(
                    shadows: const [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  characterData[currentStep - 1]['department'][0],
                  style: _departmentTextStyle1().copyWith(
                    shadows: const [
                      Shadow(
                        color: Colors.black38,
                        offset: Offset(1.5, 1.5),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // 두 번째 캐릭터
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 45, left: 10),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: const Color.fromARGB(255, 187, 205, 235),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38, // 그림자 색상
                        offset: Offset(4, 4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      characterData[currentStep - 1]['image'][1],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 9),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  characterData[currentStep - 1]['name'][1],
                  style: _nameTextStyle1().copyWith(
                    shadows: const [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  characterData[currentStep - 1]['department'][1],
                  style: _departmentTextStyle1().copyWith(
                    shadows: const [
                      Shadow(
                        color: Colors.black38,
                        offset: Offset(1.5, 1.5),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  } else {
    // 나머지 단계에서 한 명의 캐릭터 표시
    return Container(
      height: 210,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color(0xFF6A6A6A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54, // 그림자 색상
            offset: Offset(4, 4), // 그림자 위치
            blurRadius: 10,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.white24, // 하이라이트 효과
            offset: Offset(-4, -4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 15),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: const Color(0xFFF3E5F5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(4, 4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset(
                  characterData[currentStep - 1]['image'],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  characterData[currentStep - 1]['name'],
                  style: _nameTextStyle2().copyWith(
                    shadows: const [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  characterData[currentStep - 1]['department'],
                  style: _departmentTextStyle2().copyWith(
                    shadows: const [
                      Shadow(
                        color: Colors.black38,
                        offset: Offset(1.5, 1.5),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// 캐릭터 카드 및 텍스트 위젯 (음영 포함)


  Widget _buildLockStep({
    required bool isLocked,
    required String stepNumber,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // 애니메이션 지속 시간
        width: _stepSize,
        height: _stepSize,
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: isLocked ? const Color(0xFF5C48CC) : const Color(0xFFFFA726),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: _shadowOffset,
              blurRadius: _shadowBlurRadius,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              offset: const Offset(-2, -2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: GestureDetector(
          onTapDown: (_) {
            if (!isLocked) _onStepTapEffect(isPressed: true);
          },
          onTapUp: (_) {
            if (!isLocked) {
              _onStepTapEffect(isPressed: false);
              onTap();
            }
          },
          onTapCancel: () {
            if (!isLocked) _onStepTapEffect(isPressed: false);
          },
          child: Center(
            child: isLocked
                ? const Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 35,
                  )
                : Text(
                    stepNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _onStepTapEffect({required bool isPressed}) {
    setState(() {
      if (isPressed) {
        _stepSize = 65;
        _shadowBlurRadius = 5;
        _shadowOffset = const Offset(2, 2);
      } else {
        _stepSize = 70;
        _shadowBlurRadius = 10;
        _shadowOffset = const Offset(4, 4);
      }
    });
  }


  void _onStepTap(int step) {
  if (step == 1) { // 1단계를 클릭했을 때
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Step 1'),
        content: const Text('게임을 시작합니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 알림창 닫기
              _navigateToLevel1(); // Level1 페이지로 이동
            },
            child: const Text('시작'),
          ),
        ],
      ),
    );
  } else if (step <= currentStep) { // 다른 활성화된 단계 클릭 시
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Step $step'),
        content: const Text('게임을 시작합니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _completeStep(step);
            },
            child: const Text('시작'),
          ),
        ],
      ),
    );
  }
}

void _navigateToLevel1() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Level1Page()), // Level1 페이지로 이동
  );
}

void _completeStep(int step) {
  setState(() {
    if (step == currentStep) {
      currentStep++;
    }
  });
}

  TextStyle _nameTextStyle1() {
    return const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  TextStyle _departmentTextStyle1() {
    return const TextStyle(
      fontSize: 13,
      color: Colors.white70,
    );
  }

  TextStyle _nameTextStyle2() {
    return const TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  TextStyle _departmentTextStyle2() {
    return const TextStyle(
      fontSize: 17,
      color: Colors.white70,
    );
  }
}
