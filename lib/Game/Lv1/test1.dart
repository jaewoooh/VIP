import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vip/openai_api_service.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../main_navigation.dart';

class Test1Page extends StatefulWidget {
  final String userId;

  const Test1Page({super.key, required this.userId}); // userId 필수 전달

  @override
  State<Test1Page> createState() => _Test1PageState();
}

class _Test1PageState extends State<Test1Page> {
  CameraController? _cameraController;
  bool _isRecording = false;
  bool _isCameraInitialized = false;
  String? _videoPath;
  String interviewQuestion = "여기에 면접 질문 내용이 표시됩니다.";
  String userResponse = "";
  bool isLoading = false;
  bool isResponseSubmitting = false;

  final OpenAIService openAIService = OpenAIService();
  final TextEditingController responseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchInterviewQuestion();
    _initializeCamera();
  }

  @override
  void dispose() {
    if (_isRecording) {
      _stopRecordingAndUpload();
    }
    _cameraController?.dispose();
    responseController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => throw Exception('전면 카메라를 찾을 수 없습니다.'),
      );
      _cameraController = CameraController(frontCamera, ResolutionPreset.high);
      await _cameraController?.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint('카메라 초기화 오류: $e');
      _showSnackBar('전면 카메라를 초기화할 수 없습니다.');
    }
  }

  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      _showSnackBar('카메라가 초기화되지 않았습니다.');
      return;
    }
    try {
      final directory = await getApplicationDocumentsDirectory();
      final videoPath =
          '${directory.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      await _cameraController?.startVideoRecording();
      setState(() {
        _isRecording = true;
        _videoPath = videoPath;
      });
    } catch (e) {
      debugPrint('녹화 시작 오류: $e');
      _showSnackBar('녹화를 시작할 수 없습니다.');
    }
  }

  Future<void> _stopRecordingAndUpload() async {
    if (!_isRecording || _cameraController == null) return;

    try {
      final videoFile = await _cameraController?.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });

      if (videoFile != null) {
        await _uploadToFirebase(File(videoFile.path));
      }
    } catch (e) {
      debugPrint('녹화 중지 오류: $e');
      _showSnackBar('녹화를 중지하는 중 문제가 발생했습니다.');
    }
  }

  Future<void> _uploadToFirebase(File file) async {
    try {
      final timestamp = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(timestamp);
      final title = 'Test1에서 녹화된 영상 (${formattedDate} ${timestamp.hour}:${timestamp.minute})';
      final storageRef = FirebaseStorage.instance
          .ref('Users/${widget.userId}/videos/${timestamp.millisecondsSinceEpoch}.mp4');
      final uploadTask = storageRef.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('videos')
          .add({
        'videoUrl': downloadUrl,
        'recordedDate': formattedDate,
        'uploadedAt': FieldValue.serverTimestamp(),
        'title': title,
      });

      _showSnackBar('영상 업로드 완료: $title');
    } catch (e) {
      debugPrint('Firebase 업로드 오류: $e');
      _showSnackBar('영상을 저장하는 중 문제가 발생했습니다.');
    }
  }

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

  Future<void> submitResponse() async {
    if (!mounted) return;

    final response = responseController.text.trim();
    if (response.isEmpty) return;

    setState(() {
      isResponseSubmitting = true;
    });

    try {
      final result = await openAIService.evaluateResponse(response, interviewQuestion);
      if (mounted) {
        _showDialog("평가 결과", result['feedback'] as String);
      }
    } catch (error) {
      debugPrint("응답 처리 실패: $error");
      if (mounted) {
        _showDialog("오류", "응답을 처리하는 데 실패했습니다. 다시 시도해주세요.");
      }
    } finally {
      if (mounted) {
        setState(() {
          isResponseSubmitting = false;
          responseController.clear();
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경
          Positioned.fill(
            child: Stack(
              children: [
                Image.asset(
                  'assets/home3_background.png',
                  fit: BoxFit.cover,
                ),
                Container(color: Colors.black.withOpacity(0.4)),
              ],
            ),
          ),
          // 뒤로가기 버튼
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () async {
                if (_isRecording) {
                  await _stopRecordingAndUpload();
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainNavigation()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
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
                    ? const Center(child: CircularProgressIndicator())
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
          // 녹화 버튼
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed:
                    _isRecording ? _stopRecordingAndUpload : _startRecording,
                backgroundColor: _isRecording ? Colors.black : Colors.white,
                child: Icon(
                    _isRecording ? Icons.stop : Icons.fiber_manual_record),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
