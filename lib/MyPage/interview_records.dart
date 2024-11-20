// 면접기록
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위한 패키지

class InterviewRecords extends StatefulWidget {
  final Function(String, String) onFavoriteAdded;

  const InterviewRecords({super.key, required this.onFavoriteAdded});

  @override
  State<InterviewRecords> createState() => _InterviewRecordsState();
}

class _InterviewRecordsState extends State<InterviewRecords> {
  final List<bool> _isFavorite = [false, false]; // 각 항목의 하트 상태 관리
  DateTime _selectedDate = DateTime.now(); // 선택된 날짜 관리

  String get _selectedDateFormatted =>
      DateFormat('EEEE, d MMMM').format(_selectedDate); // 날짜를 문자열로 포맷

  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1F5EFF), // 달력 주요 색상
              onPrimary: Colors.white, // 선택된 날짜 텍스트 색상
              surface: Colors.black, // 배경색
              onSurface: Colors.white, // 달력 텍스트 색상
            ),
            dialogBackgroundColor: Colors.black, // 다이얼로그 배경색
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 날짜 선택 버튼
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: GestureDetector(
            onTap: () => _showDatePicker(context), // 버튼 클릭 시 달력 열기
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF1F5EFF), width: 2), // 파란 테두리
                borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDateFormatted, // 포맷된 날짜 표시
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey), // 드롭다운 아이콘
                ],
              ),
            ),
          ),
        ),
        // 리스트 뷰
        Expanded(
          child: ListView(
            children: [
              _buildListTile(
                index: 0,
                title: "2024-01-01: Software Engineer Interview",
                subtitle: "Status: Passed",
              ),
              _buildListTile(
                index: 1,
                title: "2024-02-15: Data Scientist Interview",
                subtitle: "Status: In Progress",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({required int index, required String title, required String subtitle}) {
    return ListTile(
      leading: const Icon(Icons.article, color: Colors.orange),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: IconButton(
        icon: Icon(
          _isFavorite[index] ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite[index] ? Colors.red : Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _isFavorite[index] = !_isFavorite[index];
          });
          if (_isFavorite[index]) {
            widget.onFavoriteAdded(title, subtitle);
          }
        },
      ),
    );
  }
}
