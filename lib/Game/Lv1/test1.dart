import 'package:flutter/material.dart';
import 'package:vip/openai_api_service.dart';

class Test1Page extends StatefulWidget {
  const Test1Page({super.key});

  @override
  _Test1PageState createState() => _Test1PageState();
}

class _Test1PageState extends State<Test1Page> {
  String interviewQuestion = "여기에 면접 질문 내용이 표시됩니다."; // 초기 텍스트
  String userResponse = ""; // 사용자의 입력값 저장
  bool isLoading = false;
  bool isResponseSubmitting = false;

  final OpenAIService openAIService = OpenAIService(); // OpenAIService 인스턴스 생성
  final TextEditingController responseController = TextEditingController(); // 텍스트 입력 관리

  // 면접 질문 업데이트 함수
  Future<void> fetchInterviewQuestion() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final question = await openAIService.generateInterviewQuestion();
      if (mounted) {
        setState(() {
          interviewQuestion = question;
        });
      }
    } catch (error) {
      debugPrint("API 호출 실패: $error");
      if (mounted) {
        setState(() {
          interviewQuestion = "질문을 생성하는 데 실패했습니다. 다시 시도해주세요.";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // 응답 제출 함수
  Future<void> submitResponse() async {
    if (!mounted) return;

    final response = responseController.text.trim(); // 사용자 입력값 가져오기
    if (response.isEmpty) return;

    setState(() {
      isResponseSubmitting = true;
    });

    try {
      // OpenAIService를 사용하여 응답 전송
      final result = await openAIService.evaluateResponse(response, interviewQuestion);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("평가 결과"),
              content: Text(result['feedback'] as String), // Map에서 feedback 값을 가져옴
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("확인"),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      debugPrint("응답 처리 실패: $error");
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("오류"),
              content: const Text("응답을 처리하는 데 실패했습니다. 다시 시도해주세요."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("확인"),
                ),
              ],
            );
          },
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isResponseSubmitting = false;
          responseController.clear(); // 입력 필드 초기화
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchInterviewQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Stack(
              children: [
                Image.asset(
                  'assets/home3_background.png',
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ],
            ),
          ),
          // 뒤로가기 버튼
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          // 캐릭터 이미지
          Positioned(
            top: MediaQuery.of(context).size.height * 0.12,
            left: MediaQuery.of(context).size.width * 0.5 - 210,
            child: Image.asset(
              'assets/character(1).png',
              width: 420,
              height: 420,
            ),
          ),
          // 대화 상자
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.3,
            left: 20,
            right: 20,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 230, 230, 230),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(2, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: isLoading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : Text(
                  interviewQuestion,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          // 텍스트 입력 및 제출 버튼
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: responseController,
                    decoration: const InputDecoration(
                      hintText: "답변을 입력하세요",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: isResponseSubmitting ? null : submitResponse,
                  child: const Text("제출"),
                ),
              ],
            ),
          ),
          // 새 질문 버튼
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.5 - 40,
            child: ElevatedButton(
              onPressed: isLoading ? null : fetchInterviewQuestion,
              child: const Text("새 질문"),
            ),
          ),
        ],
      ),
    );
  }
}
