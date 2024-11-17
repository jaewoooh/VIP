import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff151414), // 화면의 배경색을 검은색으로 설정
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 화면의 전체적인 내부 여백 설정
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 수직 방향으로 가운데 정렬
          children: [
            // 화면 상단 부분: 콘텐츠 (도형 + 텍스트)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 세로 방향 가운데 정렬
                children: [
                  // 도형들을 겹치기 위해 Stack 사용
                  Stack(
                    alignment: Alignment.center, // 모든 요소를 중앙에 정렬
                    children: [
                      // 큰 보라색 원
                      Container(
                        width: 200, // 원의 가로 길이
                        height: 200, // 원의 세로 길이
                        decoration: const BoxDecoration(
                          color: Colors.purple, // 보라색 배경
                          shape: BoxShape.circle, // 원형으로 설정
                        ),
                      ),
                      // 노란색 작은 원
                      Positioned(
                        top: 40, // 위에서부터 40px 떨어짐
                        left: 40, // 왼쪽에서부터 40px 떨어짐
                        child: Container(
                          width: 60, // 작은 원의 가로 길이
                          height: 60, // 작은 원의 세로 길이
                          decoration: const BoxDecoration(
                            color: Colors.yellow, // 노란색 배경
                            shape: BoxShape.circle, // 원형으로 설정
                          ),
                        ),
                      ),
                      // 흰색 테두리가 있는 원
                      Positioned(
                        top: 20, // 위에서부터 20px 떨어짐
                        right: 50, // 오른쪽에서부터 50px 떨어짐
                        child: Container(
                          width: 80, // 원의 가로 길이
                          height: 80, // 원의 세로 길이
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // 테두리 색상 흰색
                              width: 2, // 테두리 두께
                            ),
                            shape: BoxShape.circle, // 원형 테두리 설정
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30), // 도형과 텍스트 사이의 간격
                  // 제목 텍스트
                  const Text(
                    "AI 면접 게임 시작하기", // 텍스트 내용
                    style: TextStyle(
                      fontSize: 24, // 글자 크기
                      fontWeight: FontWeight.bold, // 글자의 굵기를 Bold로 설정
                      color: Colors.white, // 글자 색상 흰색
                    ),
                  ),
                  const SizedBox(height: 16), // 제목과 설명 텍스트 사이의 간격
                  // 설명 텍스트
                  const Text(
                    "다음 화면에서 원하는 직종을 선택한 후,\n게임을 시작하세요. 각 단계에서는 다양한\n면접과 연결을 진행합니다.",
                    style: TextStyle(
                      fontSize: 14, // 글자 크기
                      color: Colors.grey, // 글자 색상 회색
                      height: 1.5, // 줄 간격
                    ),
                    textAlign: TextAlign.center, // 텍스트를 중앙 정렬
                  ),
                ],
              ),
            ),
            // 화면 하단 부분: 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 버튼 간격을 양쪽 끝으로 설정
              children: [
                // Start 버튼
                ElevatedButton(
                  onPressed: () {
                    // Start 버튼 클릭 시 동작
                    debugPrint("Start Pressed");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // 버튼 배경색 흰색
                    foregroundColor: Colors.black, // 버튼 글자 색상 검은색
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0), // 버튼 테두리 둥글게 설정
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32, // 좌우 여백
                      vertical: 12, // 상하 여백
                    ),
                  ),
                  child: const Text('Start'), // 버튼 텍스트
                ),
                // Skip 버튼
                TextButton(
                  onPressed: () {
                    // Skip 버튼 클릭 시 동작
                    debugPrint("Skip Pressed");
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.purple, // 버튼 글자 색상 보라색
                  ),
                  child: const Text('Skip'), // 버튼 텍스트
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
