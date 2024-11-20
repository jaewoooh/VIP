import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/gestures.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_options.dart';
import '../main.dart';
import 'login_service.dart';
import 'register.dart';



class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      theme: ThemeData.dark(), // 다크 테마 적용
      home: const LoginScreen(), // 로그인 화면
    );
  }
}


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
            border: _buildBorder(),
            enabledBorder: _buildBorder(),
            focusedBorder: _buildBorder(),
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget buildLoginButton() {
    return ElevatedButton(
      onPressed: _isButtonActive
          ? () {
        debugPrint("Login Pressed");
      }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor:
        _isButtonActive ? const Color(0xFF8687E7) : const Color(0x808687E7),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 16,
          color: _isButtonActive ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }
  Widget buildSocialButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: SignInButton(
            Buttons.Google,
            text: "Login with Google",
            onPressed: () {
              signInWithGoogle(context); // Google 로그인 함수 호출
            },
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
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

  Widget buildRegisterText(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: const TextStyle(color: Colors.grey),
          children: [
            TextSpan(
              text: 'Register',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
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
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100),
                const Text(
                  'Login',
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
                buildLoginButton(),
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
                buildRegisterText(context),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
