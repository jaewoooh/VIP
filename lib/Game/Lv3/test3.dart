import 'package:flutter/material.dart';
import 'package:vip/main_navigation.dart';

class Test3Page extends StatelessWidget {
  const Test3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/home3_background.png', // 배경 이미지 경로
              fit: BoxFit.cover, // 화면을 꽉 채우기
            ),
          ),
          // 뒤로가기 버튼
          Positioned(
            top: 40, // 화면 상단에서 약간 아래
            left: 20, // 화면 좌측 여백
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainNavigation()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // 반투명 배경
                  shape: BoxShape.circle, // 원형 버튼
                ),
                child: const Icon(
                  Icons.arrow_back, // 뒤로가기 아이콘
                  color: Colors.white, // 아이콘 색상
                  size: 24, // 아이콘 크기
                ),
              ),
            ),
          ),
          // 캐릭터 이미지
          Positioned(
            top: MediaQuery.of(context).size.height * 0.12, // 상단 여백 조정
            left: MediaQuery.of(context).size.width * 0.5 - 210, // 중앙 배치
            child: Image.asset(
              'assets/character(1).png', // 캐릭터 이미지 경로
              width: 420, // 이미지 너비
              height: 420, // 이미지 높이
            ),
          ),
          // 대화 상자
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.13, // 하단에서 위로 올림
            left: 20, // 좌측 여백
            right: 20, // 우측 여백
            child: Container(
              height: 300, // 대화 상자 높이
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 230, 230, 230), // 대화 상자 배경색
                borderRadius: BorderRadius.circular(20), // 둥근 모서리
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // 그림자 색상
                    offset: const Offset(2, 2), // 그림자 위치
                    blurRadius: 6, // 그림자 흐림
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0), // 내부 여백
                child: Text(
                  '여기에 면접 질문 내용이 표시됩니다.', // 대화 내용
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87, // 텍스트 색상
                  ),
                ),
              ),
            ),
          ),
          // 마이크 버튼
          Positioned(
            bottom: 35, // 하단에서 약간 위로
            right: MediaQuery.of(context).size.width * 0.5 - 35, // 중앙 정렬
            child: ElevatedButton(
              onPressed: () {
                // 마이크 버튼 클릭 시 동작
                
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(), // 원형 버튼
                padding: const EdgeInsets.all(15), // 버튼 크기
                backgroundColor: const Color.fromARGB(255, 128, 128, 128), // 버튼 색상
                elevation: 5, // 버튼 그림자
              ),
              child: const Icon(
                Icons.mic, // 마이크 아이콘
                color: Colors.white, // 아이콘 색상
                size: 30, // 아이콘 크기
              ),
            ),
          ),
        ],
      ),
    );
  }
}
