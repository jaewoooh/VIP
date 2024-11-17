import 'package:flutter/material.dart';

// HomeScreen 위젯 정의 (StatelessWidget으로 변경)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text(
          "Welcome to Home Page", // 텍스트 콘텐츠
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // 텍스트 스타일
        ),
      ),
    );
  }
}
