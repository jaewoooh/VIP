import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  final String apiKey =
      ''; // API 키를 여기에 추가하세요.

  Future<String> generateInterviewQuestion() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an assistant generating interview questions.'
            },
            {'role': 'user', 'content': '면접 질문을 생성해 주세요.'}
          ],
          'max_tokens': 50,
          'temperature': 0.7,
        }),
      );

      // UTF-8 디코딩
      final decodedBody = utf8.decode(response.bodyBytes);

      // 디버깅용 출력
      print('Response status: ${response.statusCode}');
      print('Response body: $decodedBody');

      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);

        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'].trim();
        } else {
          throw Exception('Invalid response structure: $decodedBody');
        }
      } else {
        throw Exception('Failed to fetch question: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return '샘플 질문: 소프트웨어 개발에서 버전 관리의 중요성을 설명하세요.';
    }
  }

  Future<Map<String, dynamic>> evaluateResponse(String question, String answer) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a professional interviewer scoring answers to questions.'
            },
            {'role': 'user', 'content': 'Question: $question\nAnswer: $answer\nGive a score (0-100) and a brief feedback.'}
          ],
          'max_tokens': 100,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        final scoreMatch = RegExp(r'(\d{1,3})').firstMatch(content);
        final score = scoreMatch != null ? int.parse(scoreMatch.group(0)!) : 0;
        return {
          'score': score,
          'feedback': content,
        };
      } else {
        throw Exception('Failed to evaluate answer');
      }
    } catch (e) {
      return {
        'score': 0,
        'feedback': '점수 평가 실패. 다시 시도해주세요.',
      };
    }
  }
}
