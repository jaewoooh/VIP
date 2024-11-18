import 'package:flutter/material.dart';
import 'home2.dart'; // 다음 화면 (Home2Screen)으로 이동하기 위해 Home2를 import

// 홈 화면 위젯 클래스
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 제목 스타일 정의
    const TextStyle titleStyle = TextStyle(
      fontSize: 45, // 글자 크기
      fontWeight: FontWeight.bold, // 굵기
      color: Colors.white, // 색상
    );

    // 설명 텍스트 스타일 정의
    const TextStyle descriptionStyle = TextStyle(
      fontSize: 15, // 글자 크기
      color: Colors.grey, // 색상
      height: 1.5, // 줄 간격
    );

    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/home.png', // 이미지 경로
              fit: BoxFit.cover, // 화면 전체를 채우도록 설정
              errorBuilder: (context, error, stackTrace) {
                // 이미지 로드 실패 시 대체 위젯 표시
                return const Center(
                  child: Text(
                    'Error loading image', // 에러 메시지
                    style: TextStyle(
                      color: Colors.red, // 빨간색으로 표시
                      fontSize: 18, // 글자 크기
                      fontWeight: FontWeight.bold, // 굵기
                    ),
                  ),
                );
              },
            ),
          ),
          // 화면의 주요 콘텐츠
          Padding(
            padding: const EdgeInsets.all(16.0), // 전체 패딩 설정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
              children: [
                const SizedBox(height: 400), // 상단 여백
                // 화면 제목
                const Text("AI 면접 게임\n시작하기", style: titleStyle),
                const SizedBox(height: 15), // 제목 아래 간격
                // 설명 텍스트
                const Text(
                  "다음 화면에서 원하는 직종을 선택한 후,\n"
                  "게임을 시작하세요. 각 단계에서는 다양한\n"
                  "면접과 연결을 진행합니다.",
                  style: descriptionStyle,
                ),
                const SizedBox(height: 24), // 설명 아래 간격
                // 페이지네이션(작은 점 3개로 현재 화면 표시)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                  children: [
                    _buildPaginationDot(isActive: true), // 첫 번째 페이지 활성화
                    const SizedBox(width: 8), // 점 사이 간격
                    _buildPaginationDot(isActive: false), // 두 번째 페이지 비활성화
                    const SizedBox(width: 8), // 점 사이 간격
                    _buildPaginationDot(isActive: false), // 세 번째 페이지 비활성화
                  ],
                ),
                const SizedBox(height: 50), // 페이지네이션 아래 간격
                // 하단 버튼 2개 (Next, Skip)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                  children: [
                    // Next 버튼
                    _buildButton(
                      label: 'Next', // 버튼 텍스트
                      backgroundColor: Colors.white, // 버튼 배경 색상
                      textColor: Colors.black, // 버튼 텍스트 색상
                      onPressed: () {
                        // 버튼 클릭 시 Home2Screen으로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home2Screen(), // Home2Screen 호출
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 80), // 버튼 사이 간격
                    // Skip 버튼
                    _buildButton(
                      label: 'Skip', // 버튼 텍스트
                      backgroundColor: const Color(0xff5500AA), // 보라색 배경
                      textColor: Colors.white, // 버튼 텍스트 색상
                      onPressed: () => debugPrint("Skip Pressed"), // 클릭 시 메시지 출력
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

  /// 페이지네이션 점 빌더
  /// 활성화된 점과 비활성화된 점을 구분
  Widget _buildPaginationDot({bool isActive = false}) {
    return Container(
      width: isActive ? 20 : 5, // 활성화된 점은 더 넓음
      height: 5, // 점 높이
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey, // 활성화 여부에 따라 색상 변경
        borderRadius: BorderRadius.circular(3), // 둥근 모서리
      ),
    );
  }

  /// 버튼 생성 함수
  /// 공통 스타일을 적용한 버튼 생성
  Widget _buildButton({
    required String label, // 버튼 텍스트
    required Color backgroundColor, // 버튼 배경 색상
    required Color textColor, // 버튼 텍스트 색상
    required VoidCallback onPressed, // 버튼 클릭 이벤트
  }) {
    return ElevatedButton(
      onPressed: onPressed, // 클릭 시 실행할 함수
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // 배경 색상
        foregroundColor: textColor, // 텍스트 색상
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // 버튼 모서리 둥글게
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 50, // 버튼 좌우 여백
          vertical: 16, // 버튼 위아래 여백
        ),
      ),
      child: Text(label), // 버튼 텍스트
    );
  }
}
