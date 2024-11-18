//DailyTask Container
import 'package:flutter/material.dart';

class DailyTask extends StatelessWidget {
  final int completedTasks; // 완료된 작업 수
  final int totalTasks; // 전체 작업 수
  final String motivationMessage; // 동기부여 메시지

  const DailyTask({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
    required this.motivationMessage,
  });

  @override
  Widget build(BuildContext context) {
    double progress = completedTasks / totalTasks; // 진행률 계산
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900, // 짙은 회색 배경색
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily Task",
            style: TextStyle(
              color: Colors.white, // 흰색 텍스트
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              // 동기부여 텍스트
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "\"$motivationMessage\"",
                  style: const TextStyle(color: Colors.grey, fontSize: 12), // 회색 텍스트
                ),
              ),
              // ProgressBar 위의 퍼센트 텍스트
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${(progress * 100).toInt()}%", // 퍼센트 표시
                  style: const TextStyle(color: Colors.white, fontSize: 14), // 흰색 텍스트
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // ProgressBar
          Container(
            height: 15, // ProgressBar 높이
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.shade800, // ProgressBar 배경색
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5), // 진행 막대 둥글게 설정
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent, // 배경 투명
                color: Colors.purple, // 진행 막대 색상
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "$completedTasks/$totalTasks Task Completed",
            style: const TextStyle(color: Colors.grey, fontSize: 14), // 회색 텍스트
          ),
        ],
      ),
    );
  }
}
