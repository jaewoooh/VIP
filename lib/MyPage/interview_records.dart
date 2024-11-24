import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vip/MyPage/videoplayer.dart';
import 'package:intl/intl.dart';

class InterviewRecords extends StatefulWidget {
  final String userId;

  const InterviewRecords({super.key, required this.userId});

  @override
  State<InterviewRecords> createState() => _InterviewRecordsState();
}

class _InterviewRecordsState extends State<InterviewRecords> {
  List<Map<String, dynamic>> _videos = [];
  DateTime _selectedDate = DateTime.now(); // 선택한 날짜

  // 선택한 날짜를 yyyy-MM-dd 형식으로 변환
  String get _selectedDateFormatted =>
      DateFormat('yyyy-MM-dd').format(_selectedDate);

  Future<void> _fetchVideos() async {
    try {
      // Firestore에서 recordedDate가 선택된 날짜와 일치하는 문서만 가져오기
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('videos')
          .where('recordedDate', isEqualTo: _selectedDateFormatted)
          .orderBy('uploadedAt', descending: true)
          .get();

      debugPrint('쿼리 실행: recordedDate = $_selectedDateFormatted');
      debugPrint('Firestore 반환된 문서 수: ${snapshot.docs.length}');

      // 데이터를 _videos 리스트에 저장
      setState(() {
        _videos = snapshot.docs.map((doc) {
          final data = doc.data();
          debugPrint('문서 데이터: $data');
          return {
            'videoUrl': data['videoUrl'],
            'recordedDate': data['recordedDate'],
            'uploadedAt': data['uploadedAt'],
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('Firestore 데이터 가져오기 오류: $e');
    }
  }

  void _showDatePicker(BuildContext context) async {
    // 달력에서 날짜 선택
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF1F5EFF),
            colorScheme: ColorScheme.light(primary: const Color(0xFF1F5EFF)),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // 선택된 날짜를 설정하고 새로운 데이터 가져오기
      setState(() {
        _selectedDate = picked;
      });
      _fetchVideos();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchVideos(); // 초기 데이터 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('인터뷰 기록'),
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              onPressed: () => _showDatePicker(context), // 달력 아이콘 클릭
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1F5EFF),
      ),
      body: _videos.isEmpty
          ? Center(
        child: Text(
          '선택한 날짜 (${_selectedDateFormatted})에 저장된 영상이 없습니다.',
          style: const TextStyle(color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          return ListTile(
            leading: const Icon(Icons.video_file, color: Colors.orange),
            title: Text(
              video['recordedDate'] ?? '기록된 날짜 없음',
              style: const TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              '녹화 시간: ${video['uploadedAt']?.toDate() ?? '시간 정보 없음'}',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.black),
              onPressed: () {
                debugPrint('재생할 URL: ${video['videoUrl']}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChewiePlayerScreen(
                      videoUrl: video['videoUrl'] ?? '',
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
