import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  CameraController? _cameraController; // 카메라 컨트롤러
  bool _isRecording = false; // 녹화 상태
  String? _videoPath; // 녹화된 파일 경로

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  /// 카메라 초기화
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      // 전면 카메라가 있는지 확인
      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => throw Exception('전면 카메라를 찾을 수 없습니다.'),
      );

      _cameraController = CameraController(frontCamera, ResolutionPreset.high);
      await _cameraController?.initialize();
      setState(() {});
      _startRecording(); // 초기화 후 녹화 시작
    } catch (e) {
      debugPrint('카메라 초기화 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('전면 카메라를 초기화할 수 없습니다.')),
      );
    }
  }


  /// 녹화 시작
  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카메라가 초기화되지 않았습니다.')),
      );
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

      debugPrint('녹화 시작: $videoPath');
    } catch (e) {
      debugPrint('녹화 시작 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('녹화를 시작할 수 없습니다.')),
      );
    }
  }

  /// 녹화 중지 및 Firebase 업로드
  Future<void> _stopRecordingAndUpload() async {
    if (!_isRecording || _cameraController == null) return;

    try {
      final videoFile = await _cameraController?.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });

      if (videoFile != null) {
        debugPrint('녹화 중지: ${videoFile.path}');
        await _uploadToFirebase(File(videoFile.path)); // Firebase에 업로드
      }
    } catch (e) {
      debugPrint('녹화 중지 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('녹화를 중지하는 중 문제가 발생했습니다.')),
      );
    }
  }

  /// Firebase Storage 및 Firestore 업로드
  // Firebase Storage 및 Firestore 업로드
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

      debugPrint('Firebase 업로드 완료: $downloadUrl');

      // Firestore에 메타데이터 저장
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('videos')
          .add({
        'videoUrl': downloadUrl,                  // Firebase Storage URL
        'recordedDate': formattedDate,           // 녹화 날짜
        'uploadedAt': FieldValue.serverTimestamp(), // 업로드 시간
        'title': title,                          // 비디오 제목
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('영상 업로드 완료: $title')),
      );
    } catch (e) {
      debugPrint('Firebase 업로드 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('영상을 저장하는 중 문제가 발생했습니다.')),
      );
    }
  }



  @override
  void dispose() {
    if (_isRecording) {
      _stopRecordingAndUpload(); // 화면 종료 시 녹화 중단 및 업로드
    }
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/home3_background.png', // 배경 이미지 경로
              fit: BoxFit.cover, // 화면을 꽉 채우기
            ),
          ),
          // 녹화 중 아이콘
          if (_isRecording)
            Positioned(
              top: 40,
              right: 20,
              child: Icon(
                Icons.circle,
                color: Colors.red,
                size: 24,
              ),
            ),
          // 뒤로가기 버튼
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () async {
                await _stopRecordingAndUpload(); // 녹화 중단 및 업로드
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainNavigation()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // 반투명 배경
                  shape: BoxShape.circle, // 원형 버튼
                ),
                child: const Icon(
                  Icons.arrow_back, // 뒤로가기 아이콘
                  color: Colors.white, // 아이콘 색상
                  size: 24, // 아이콘 크기
                ),
              ),
            ),
          ),
          // 캐릭터 이미지
          Positioned(
            top: MediaQuery.of(context).size.height * 0.12, // 상단 여백 조정
            left: MediaQuery.of(context).size.width * 0.5 - 210, // 중앙 배치
            child: Image.asset(
              'assets/character(1).png', // 캐릭터 이미지 경로
              width: 420, // 이미지 너비
              height: 420, // 이미지 높이
            ),
          ),
          // 대화 상자
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.13, // 하단에서 위로 올림
            left: 20, // 좌측 여백
            right: 20, // 우측 여백
            child: Container(
              height: 300, // 대화 상자 높이
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 230, 230, 230), // 대화 상자 배경색
                borderRadius: BorderRadius.circular(20), // 둥근 모서리
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // 그림자 색상
                    offset: const Offset(2, 2), // 그림자 위치
                    blurRadius: 6, // 그림자 흐림
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0), // 내부 여백
                child: Text(
                  '여기에 면접 질문 내용이 표시됩니다.', // 대화 내용
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87, // 텍스트 색상
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}