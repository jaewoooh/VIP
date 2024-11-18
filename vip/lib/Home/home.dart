import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 공통 스타일 및 속성 정의
    const TextStyle titleStyle = TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    const TextStyle descriptionStyle = TextStyle(
      fontSize: 15,
      color: Colors.grey,
      height: 1.5,
    );

    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/home.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text(
                    'Error loading image',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          // 콘텐츠
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 350), // 상단 여백 조정
                // 제목 텍스트
                const Text("AI 면접 게임\n시작하기", style: titleStyle),
                const SizedBox(height: 15),
                // 설명 텍스트
                const Text(
                  "다음 화면에서 원하는 직종을 선택한 후,\n"
                  "게임을 시작하세요. 각 단계에서는 다양한\n"
                  "면접과 연결을 진행합니다.",
                  style: descriptionStyle,
                ),
                const SizedBox(height: 24),
                // 페이지네이션
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildPaginationDot(isActive: true),
                    const SizedBox(width: 8),
                    _buildPaginationDot(),
                    const SizedBox(width: 8),
                    _buildPaginationDot(),
                  ],
                ),
                const SizedBox(height: 50), // 여백 조정
                // 하단 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Next 버튼
                    _buildButton(
                      label: 'Next',
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      onPressed: () => debugPrint("Next Pressed"),
                    ),
                    const SizedBox(width: 80), // 버튼 간격
                    // Skip 버튼
                    _buildButton(
                      label: 'Skip',
                      backgroundColor: const Color(0xff5500AA),
                      textColor: Colors.white,
                      onPressed: () => debugPrint("Skip Pressed"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 페이지네이션 점 빌더
  Widget _buildPaginationDot({bool isActive = false}) {
    return Container(
      width: isActive ? 20 : 5,
      height: 5,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  // 버튼 위젯 빌더
  Widget _buildButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 16,
        ),
      ),
      child: Text(label),
    );
  }
}
