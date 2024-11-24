//즐겨찾기
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위한 패키지

class Favorites extends StatefulWidget {
  final List<Map<String, String>> favoriteItems; // 즐겨찾기 항목 리스트

  const Favorites({super.key, required this.favoriteItems});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  // 선택된 날짜를 관리하는 변수
  DateTime _selectedDate = DateTime.now();

  // 선택된 날짜를 특정 형식으로 포맷하는 getter
  String get _selectedDateFormatted =>
      DateFormat('EEEE, d MMMM').format(_selectedDate);

  // 달력 팝업을 표시하는 함수
  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // 현재 선택된 날짜를 초기값으로 설정
      firstDate: DateTime(2000), // 선택 가능한 최소 날짜
      lastDate: DateTime(2100), // 선택 가능한 최대 날짜
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            // 달력의 색상 테마 설정
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1F5EFF), // 주요 색상
              onPrimary: Colors.white, // 선택된 날짜의 텍스트 색상
              surface: Colors.black, // 배경색
              onSurface: Colors.white, // 달력 텍스트 색상
            ),
            dialogBackgroundColor: Colors.black, // 다이얼로그 배경색
          ),
          child: child!, // 실제 달력 위젯
        );
      },
    );

    // 새로운 날짜가 선택되었을 경우 상태 업데이트
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // 선택된 날짜를 업데이트
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
            onTap: () => _showDatePicker(context), // 클릭 시 달력 열기
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95, // 버튼 너비 설정
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF1F5EFF), width: 2), // 테두리 색상과 두께
                borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게 처리
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 좌우 요소 간격 조정
                children: [
                  // 포맷된 날짜 텍스트
                  Text(
                    _selectedDateFormatted,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey), // 드롭다운 아이콘
                ],
              ),
            ),
          ),
        ),
        // 즐겨찾기 리스트 뷰
        Expanded(
          child: ListView.builder(
            itemCount: widget.favoriteItems.length, // 즐겨찾기 항목 수
            itemBuilder: (context, index) {
              final item = widget.favoriteItems[index]; // 현재 항목
              return ListTile(
                // 왼쪽의 하트 아이콘
                leading: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      widget.favoriteItems.removeAt(index); // 항목 삭제
                    });
                  },
                ),
                title: Text(
                  item['title']!, // 즐겨찾기 제목
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  item['subtitle']!, // 즐겨찾기 부제목
                  style: const TextStyle(color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
