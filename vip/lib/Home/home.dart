import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          SizedBox.expand(
            child: Image.asset(
              'assets/home.png', // 배경 이미지 경로
              fit: BoxFit.cover, // 이미지 크기 맞춤
              errorBuilder: (context, error, stackTrace) {
                // 이미지 로드 실패 시 대체 위젯
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
          // 텍스트와 버튼 배치
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 상단 빈 공간을 더 크게 만들어 텍스트를 아래로 이동
                const SizedBox(height: 380), // 원하는 만큼 높이 추가
                // 텍스트 콘텐츠
                Align(
                  alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 제목 텍스트
                      const Text(
                        "AI 면접 게임\n"
                        "시작하기",
                        style: TextStyle(
                          fontSize: 45, // 제목 글자 크기
                          fontWeight: FontWeight.bold, // 글자 굵기
                          color: Colors.white, // 글자 색상
                        ),
                      ),
                      const SizedBox(height: 15), // 제목과 설명 텍스트 간격
                      // 설명 텍스트
                      const Text(
                        "다음 화면에서 원하는 직종을 선택한 후,\n"
                        "게임을 시작하세요. 각 단계에서는 다양한\n"
                        "면접과 연결을 진행합니다.",
                        style: TextStyle(
                          fontSize: 15, // 설명 글자 크기
                          color: Colors.grey, // 글자 색상
                          height: 1.5, // 줄 간격
                        ),
                      ),
                      const SizedBox(height: 24), // 설명 텍스트와 페이지네이션 간격
                      // 페이지네이션 (하얀 점 + 회색 점)
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white, // 활성화된 페이지네이션 색상
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8), // 점 사이 간격
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey, // 비활성화된 페이지네이션 색상
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey, // 비활성화된 페이지네이션 색상
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50), // 간격을 조정하여 버튼 위치 조절
                // 하단 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                  children: [
                    // Next 버튼
                    ElevatedButton(
                      onPressed: () {
                        debugPrint("Next Pressed");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Next'),
                    ),
                    // 버튼 사이 간격 좁히기
                    const SizedBox(width: 80), // 버튼 간격 설정
                    // Skip 버튼
                    ElevatedButton(
                      onPressed: () {
                        debugPrint("Skip Pressed");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff5500AA),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Skip'),
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
}
