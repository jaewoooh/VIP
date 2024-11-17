import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/gestures.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 입력 필드 컨트롤러
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 로그인 버튼 활성화 상태를 관리하는 변수
  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();

    // 입력 필드 상태 변경을 감지하여 버튼 활성화 상태 업데이트
    _usernameController.addListener(_validateInputs);
    _passwordController.addListener(_validateInputs);
  }

  void _validateInputs() {
    // 입력 필드에 텍스트가 모두 존재하면 버튼 활성화
    setState(() {
      _isButtonActive = _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    // 입력 필드 컨트롤러 메모리 해제
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 텍스트 필드 생성 메서드
  Widget buildTextField({
    required String label, // 텍스트 필드 레이블
    required String hint, // 힌트 텍스트
    required TextEditingController controller, // 연결된 컨트롤러
    bool isPassword = false, // 비밀번호 입력 여부 (기본값: false)
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 텍스트 필드 레이블
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 12), // 레이블과 텍스트 필드 간격
        TextField(
          controller: controller, // 컨트롤러 연결
          obscureText: isPassword, // 비밀번호 입력 시 텍스트 숨김 여부
          decoration: InputDecoration(
            hintText: hint, // 힌트 텍스트 설정
            filled: true, // 배경 색 활성화
            fillColor: Colors.grey[900], // 배경 색 지정
            border: _buildBorder(), // 기본 테두리
            enabledBorder: _buildBorder(), // 활성화 상태 테두리
            focusedBorder: _buildBorder(), // 포커스 상태 테두리
            hintStyle: const TextStyle(color: Colors.grey), // 힌트 텍스트 스타일
          ),
          style: const TextStyle(color: Colors.white), // 입력 텍스트 스타일
        ),
      ],
    );
  }

  // 텍스트 필드 테두리 생성 메서드
  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey), // 테두리 색상
      borderRadius: BorderRadius.circular(8), // 테두리 둥글기
    );
  }

  // 로그인 버튼 생성 메서드
  Widget buildLoginButton() {
    return ElevatedButton(
      // 버튼 동작 설정: 활성화 상태에서만 동작
      onPressed: _isButtonActive
          ? () {
              debugPrint("Login Pressed"); // 로그인 버튼 클릭 시 출력
            }
          : null, // 비활성화 상태일 경우 동작 없음
      style: ButtonStyle(
        // 버튼 배경 색상
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          // 비활성화 상태
          if (states.contains(WidgetState.disabled)) {
            return const Color(0x808687E7);
          }
          // 활성화 상태
          return const Color(0xFF8687E7);
        }),
        // 버튼 패딩
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16),
        ),
        // 버튼 모양 (둥근 테두리)
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      // 버튼 텍스트
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 16, // 글자 크기
          color: _isButtonActive ? Colors.white : Colors.grey[600], // 색상
        ),
      ),
    );
  }

  // 소셜 로그인 버튼 묶음 생성
 Widget buildSocialButtons() {
  return Column(
    children: [
      // 구글 로그인 버튼
      SizedBox(
        width: double.infinity, // 버튼의 너비를 최대한으로 설정
        child: SignInButton(
          Buttons.Google,
          text: "Login with Google",
          onPressed: () {
            debugPrint("Google Login Pressed");
          },
        ),
      ),
      const SizedBox(height: 5), // 버튼 간격
      // 애플 로그인 버튼
      SizedBox(
        width: double.infinity, // 버튼의 너비를 최대한으로 설정
        child: SignInButton(
          Buttons.Apple,
          text: "Login with Apple",
          onPressed: () {
            debugPrint("Apple Login Pressed");
          },
        ),
      ),
    ],
  );
}

  // 회원가입 텍스트 생성
  Widget buildRegisterText(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ", // 기본 텍스트
          style: const TextStyle(color: Colors.grey),
          children: [
            TextSpan(
              text: 'Register', // 회원가입 버튼 텍스트
              style: const TextStyle(
                color: Colors.white, // 텍스트 색상
                fontWeight: FontWeight.bold, // 글자 굵기
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // 회원가입 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 화면 터치 시 키보드 닫기
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black, // 배경 색상
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0), // 가로 패딩
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100), // 상단 여백
                // 로그인 제목
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32, // 글자 크기
                    fontWeight: FontWeight.bold, // 글자 굵기
                    color: Colors.white, // 글자 색상
                  ),
                ),
                const SizedBox(height: 50), // 제목과 입력 필드 간격
                // 사용자 이름 입력 필드
                buildTextField(
                  label: 'Username',
                  hint: 'Enter your Username',
                  controller: _usernameController,
                ),
                const SizedBox(height: 30), // 입력 필드 간격
                // 비밀번호 입력 필드
                buildTextField(
                  label: 'Password',
                  hint: 'Enter your Password',
                  isPassword: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 30), // 버튼 간격
                // 로그인 버튼
                buildLoginButton(),
                const SizedBox(height: 30), // 구분선 간격
                // 구분선
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'or',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 30), // 소셜 로그인 버튼 간격
                // 소셜 로그인 버튼
                buildSocialButtons(),
                const SizedBox(height: 40), // 회원가입 텍스트 간격
                // 회원가입 텍스트
                buildRegisterText(context),
                const SizedBox(height: 50), // 하단 여백
              ],
            ),
          ),
        ),
      ),
    );
  }
}
