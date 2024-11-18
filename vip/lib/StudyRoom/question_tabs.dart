//Question List
import 'package:flutter/material.dart';
import 'answer_page.dart'; // 답변 확인 페이지 import

class QuestionTabs extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onTaskComplete; // 작업 완료 콜백

  const QuestionTabs({
    super.key,
    required this.searchQuery,
    required this.onTaskComplete, // 작업 완료 콜백 전달받기
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // 탭 개수
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 탭바
          Container(
            color: Colors.black, // 배경색 설정
            child: const TabBar(
              isScrollable: true, // 스크롤 가능하도록 설정
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.orange, width: 3), // 주황색 선
                insets: EdgeInsets.symmetric(horizontal: 50.0), // 주황색 선 길이
              ),
              indicatorColor: Colors.transparent, // 기본 회색선 제거
              dividerColor: Colors.transparent, // 탭바 아래 회색선 제거
              labelColor: Colors.orange, // 선택된 탭 텍스트 색상
              unselectedLabelColor: Colors.grey, // 선택되지 않은 탭 텍스트 색상
              labelStyle: TextStyle(
                fontSize: 17, // 선택된 탭 텍스트 크기
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16, // 선택되지 않은 탭 텍스트 크기
              ),
              tabs: [
                Tab(text: "경영 관리"),
                Tab(text: "소프트웨어 개발"),
                Tab(text: "마케팅 전략"),
                Tab(text: "회계와 재무"),
                Tab(text: "영업 관리"),
              ],
            ),
          ),

          // Question List Label
          const Padding(
            padding: EdgeInsets.only(top: 20.0, left: 16.0, bottom: 5.0),
            child: Text(
              "Question List",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 하이라이트된 단어들만 리스트업
          if (searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Results for \"$searchQuery\":",
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          if (searchQuery.isNotEmpty)
            Expanded(
              child: _buildFilteredList(context), // 하이라이트된 항목만 표시
            )
          else
            Expanded(
              child: TabBarView(
                children: [
                  _buildQuestionList(context),
                  _buildQuestionList(context),
                  _buildQuestionList(context),
                  _buildQuestionList(context),
                  _buildQuestionList(context),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionList(BuildContext context) {
    List<String> questions = [
      "Q. 면접자는 문제해결을 왜 해야 한다고 생각하십니까?",
      "Q. 지원한 직무가 어떤 직무인지 알고 계시다면 설명 부탁드립니다.",
      "Q. 귀하가 함께 근무하는 팀 동료가 이직을 생각하고 있다면?", // 추가된 질문
      "Q. 본인에게는 팀 프로젝트를 하면서 가장 어려웠던 것은 무엇이었습니까?", // 추가된 질문
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: questions.map((question) {
        return Card(
          color: Colors.grey.shade900,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 주황색 점 추가
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6, right: 12),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                // 질문 텍스트
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: _highlightSearchText(question, searchQuery),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                // 버튼
                InkWell(
                  onTap: () {
                    // 작업 완료 콜백 호출
                    onTaskComplete();

                    // `AnswerPage`로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnswerPage(question: question),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/button_icon.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFilteredList(BuildContext context) {
    List<String> questions = [
      "Q. 면접자는 문제해결을 왜 해야 한다고 생각하십니까?",
      "Q. 지원한 직무가 어떤 직무인지 알고 계시다면 설명 부탁드립니다.",
      "Q. 귀하가 함께 근무하는 팀 동료가 이직을 생각하고 있다면?",
      "Q. 본인에게는 팀 프로젝트를 하면서 가장 어려웠던 것은 무엇이었습니까?",
    ];

    // 검색어가 포함된 질문만 필터링
    List<String> filteredQuestions = questions
        .where((question) => question.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return ListView(
      padding: EdgeInsets.zero,
      children: filteredQuestions.map((question) {
        return Card(
          color: Colors.grey.shade900,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 주황색 점 추가
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6, right: 12),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                // 질문 텍스트
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: _highlightSearchText(question, searchQuery),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                // 버튼
                InkWell(
                  onTap: () {
                    // 작업 완료 콜백 호출
                    onTaskComplete();

                    // `AnswerPage`로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnswerPage(question: question),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/button_icon.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  List<TextSpan> _highlightSearchText(String text, String searchQuery) {
    if (searchQuery.isEmpty) {
      return [TextSpan(text: text)];
    }

    final matches = RegExp(searchQuery, caseSensitive: false).allMatches(text);

    if (matches.isEmpty) {
      return [TextSpan(text: text)];
    }

    int currentIndex = 0;
    List<TextSpan> spans = [];

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
      }
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      ));
      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return spans;
  }
}
