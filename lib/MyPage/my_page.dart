import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vip/Login&Register/login.dart'; // 로그인 화면이 있는 파일 import 필요
import 'interview_records.dart';
import 'favorites.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final List<Map<String, String>> _favoriteItems = [];

  // FirebaseAuth 인스턴스
  final User? _user = FirebaseAuth.instance.currentUser;

  void _addToFavorites(String title, String subtitle) {
    setState(() {
      _favoriteItems.add({'title': title, 'subtitle': subtitle});
    });
  }

  // 로그아웃 메서드
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Firebase 로그아웃
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()), // 로그인 화면으로 이동
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그아웃 중 오류 발생: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 프로필 제목 및 변경 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My profile",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _logout(context), // 로그아웃 메서드 실행
                    child: const Text(
                      "로그아웃",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 프로필 박스
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 구글 로그인 이름과 이메일 표시
                        Text(
                          _user?.displayName ?? "사용자 이름 없음",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // 텍스트 색상 변경
                          ),
                        ),
                        Text(
                          _user?.email ?? "이메일 없음",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TabBar(
                        indicatorColor: Colors.orange,
                        labelColor: Colors.orange,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: "면접 기록"),
                          Tab(text: "즐겨찾기"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: TabBarView(
                          children: [
                            InterviewRecords(onFavoriteAdded: _addToFavorites),
                            Favorites(favoriteItems: _favoriteItems),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
