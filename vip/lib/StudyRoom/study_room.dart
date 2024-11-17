import 'package:flutter/material.dart';

class StudyRoomScreen extends StatelessWidget {
  const StudyRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Room"),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text(
          "Welcome to Study Room",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
