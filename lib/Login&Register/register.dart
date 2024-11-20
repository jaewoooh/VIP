import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 입력 필드 컨트롤러
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // 회원가입 버튼 활성화 상태를 관리하는 변수
  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();

    // 입력 필드 상태 변경을 감지하여 버튼 활성화 상태 업데이트
    _usernameController.addListener(_validateInputs);
    _passwordController.addListener(_validateInputs);
    _confirmPasswordController.addListener(_validateInputs);
  }

  void _validateInputs() {
    // 입력 필드가 모두 채워지고 비밀번호와 확인 비밀번호가 같으면 버튼 활성화
    setState(() {
      _isButtonActive = _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text == _passwordController.text;
    });
  }

  @override
  void dispose() {
    // 입력 필드 컨트롤러 메모리 해제
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 텍스트 필드 생성 메서드
  Widget buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  // 회원가입 버튼 생성 메서드
  Widget buildRegisterButton() {
    return ElevatedButton(
      onPressed: _isButtonActive
          ? () {
              // 회원가입 버튼 클릭 시 동작
              debugPrint("Register Pressed");
            }
          : null, // 비활성화 상태일 경우 동작 없음
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0x808687E7); // 비활성화 상태 (회색)
          }
          return const Color(0xFF8687E7); // 활성화 상태 (보라색)
        }),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: Text(
        'Register',
        style: TextStyle(
          fontSize: 16,
          color: _isButtonActive ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }

  // 소셜 회원가입 버튼 묶음 생성
  Widget buildSocialButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: SignInButton(
            Buttons.Google,
            text: "Register with Google",
            onPressed: () {
              debugPrint("Google Register Pressed");
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: SignInButton(
            Buttons.Apple,
            text: "Register with Apple",
            onPressed: () {
              debugPrint("Apple Register Pressed");
            },
          ),
        ),
      ],
    );
  }

  // 로그인 텍스트 생성
  Widget buildLoginText(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Already have an account? ",
          style: const TextStyle(color: Colors.grey),
          children: [
            TextSpan(
              text: 'Login',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context); // 로그인 화면으로 돌아가기
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
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),
                buildTextField(
                  label: 'Username',
                  hint: 'Enter your Username',
                  controller: _usernameController,
                ),
                const SizedBox(height: 30),
                buildTextField(
                  label: 'Password',
                  hint: 'Enter your Password',
                  isPassword: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 30),
                buildTextField(
                  label: 'Confirm Password',
                  hint: 'Confirm your Password',
                  isPassword: true,
                  controller: _confirmPasswordController,
                ),
                const SizedBox(height: 30),
                buildRegisterButton(),
                const SizedBox(height: 30),
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
                const SizedBox(height: 30),
                buildSocialButtons(),
                const SizedBox(height: 40),
                buildLoginText(context),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
