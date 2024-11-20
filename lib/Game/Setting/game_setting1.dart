import 'package:flutter/material.dart';
import 'game_setting2.dart'; // Home3Screen import

// 해야할것: 대분류, 중분류, 소분류에 ai 데이터셋과 연결하여 직종 분류들 넣기
// 대->중->소 / 대 / 대->중 선택은 가능하지만 중->소/ 소 선택은 불가능하게 (무조건 대분류는 필수 선택)
// 조건 부여해주기


class Home2Screen extends StatefulWidget {
  const Home2Screen({super.key});

  @override
  State<Home2Screen> createState() => _Home2ScreenState();
}

class _Home2ScreenState extends State<Home2Screen> {
  // 각 드롭다운 초기값 및 선택 상태 관리
  final Map<String, dynamic> categories = {
    '대분류': {'value': '선택 안함', 'selected': false},
    '중분류': {'value': '선택 안함', 'selected': false},
    '소분류': {'value': '선택 안함', 'selected': false},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 화면 배경색
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0), // 화면 전체 패딩
          child: Column(
            children: [
              // 상단 뒤로가기 버튼
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context), // 이전 화면으로 돌아가기
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 30), // 뒤로가기 버튼 아래 간격

              // 단계 표시 (원과 줄을 포함하는 Row)
              _buildStepIndicatorRow(),
              const SizedBox(height: 50), // 단계와 드롭다운 간 간격

              // 드롭다운 메뉴
              _buildDropdown('대분류'),
              const SizedBox(height: 20), // 드롭다운 간의 간격
              _buildDropdown('중분류'),
              const SizedBox(height: 20), // 드롭다운 간의 간격
              _buildDropdown('소분류'),

              const SizedBox(height: 30), // 드롭다운과 페이지네이션 간격

              // // 페이지네이션 점 표시
              // _buildPaginationRow(),
              const SizedBox(height: 140,), // 남은 공간을 위로 밀기

              // 하단 버튼 (Next Page)
              _buildActionButton(
                label: 'Next Page',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                onPressed: () {
                  // Home3Screen으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home3Screen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 단계 표시용 원과 텍스트를 빌드하는 Row
  Widget _buildStepIndicatorRow() {
    final labels = ['대분류', '중분류', '소분류'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < labels.length; i++) ...[
          _buildStepIndicator(labels[i], i + 1),
          if (i < labels.length - 1) _buildLine(), // 마지막 원 뒤에는 줄 추가 X
        ],
      ],
    );
  }

  /// 단계 표시용 원과 텍스트를 빌드하는 함수
  Widget _buildStepIndicator(String label, int stepNumber) {
    final isSelected = categories[label]!['selected'] as bool;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isSelected
              ? const Color.fromARGB(255, 66, 136, 228) // 선택된 경우 파란색
              : const Color.fromARGB(255, 95, 103, 112), // 선택되지 않은 경우 회색
          child: Text(
            isSelected ? "✔" : stepNumber.toString().padLeft(2, '0'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  /// 원과 원 사이의 줄을 빌드하는 함수
  Widget _buildLine() {
    return Transform.translate(
      offset: const Offset(0, -12),
      child: Container(
        width: 120,
        height: 2,
        color: Colors.grey,
      ),
    );
  }

  // /// 페이지네이션 점 표시 Row
  // Widget _buildPaginationRow() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       _buildPaginationDot(isActive: false),
  //       const SizedBox(width: 8),
  //       _buildPaginationDot(isActive: true),
  //       const SizedBox(width: 8),
  //       _buildPaginationDot(isActive: false),
  //     ],
  //   );
  // }

  // /// 페이지네이션 점 빌더 함수
  // Widget _buildPaginationDot({bool isActive = false}) {
  //   return Container(
  //     width: isActive ? 20 : 5,
  //     height: 5,
  //     decoration: BoxDecoration(
  //       color: isActive ? Colors.white : Colors.grey,
  //       borderRadius: BorderRadius.circular(3),
  //     ),
  //   );
  // }

  /// 드롭다운 빌드 함수
  Widget _buildDropdown(String label) {
    final value = categories[label]!['value'] as String;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17), // 드롭다운 위아래 간격 조정 제거
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        dropdownColor: Colors.grey[800],
        items: _getDropdownItems(label),
        onChanged: (newValue) {
          setState(() {
            categories[label]!['value'] = newValue;
            categories[label]!['selected'] = newValue != "선택 안함";
          });
        },
      ),
    );
  }

  /// 드롭다운 항목 빌더 함수
  List<DropdownMenuItem<String>> _getDropdownItems(String label) {
    final items = {
      '대분류': ["선택 안함", "IT/데이터", "식품", "섬유/의복", "기계", "건설", "서비스", "경영"],
      '중분류': ["선택 안함", "옵션 1", "옵션 2"],
      '소분류': ["선택 안함", "옵션 1", "옵션 2"]
    }[label]!;
    return items
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ))
        .toList();
  }

  /// 하단 버튼 빌드 함수
  Widget _buildActionButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 13),
      ),
      child: Text(label),
    );
  }
}
