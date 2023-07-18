import 'package:flutter/material.dart';
import 'package:untitled/resources/auth_methods.dart';
import 'package:untitled/screens/signup_screen.dart';
import 'package:untitled/utils/colors.dart';
import 'package:untitled/utils/utils.dart';
import 'package:untitled/widgets/text_field_input.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              //image
              Row(
                children: [
                  Image(
                    image: AssetImage('assets/wavinghand.png'),
                    height: 64,
                  ),
                  SizedBox(width: 16), // Add spacing between the two images
                  Image(
                    image: AssetImage('assets/logo_helphand.png'),
                    color: primaryColor,
                    height: 64,
                  ),
                ],
              ),

              const SizedBox(height: 64),
              //text field input for email
              TextFieldInput(
                hintText: '이메일 주소',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              //text field input for password
              TextFieldInput(
                hintText: '비밀번호',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              //button login
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: InkWell(
                  onTap: loginUser,
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: blueColor2,
                    ),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                        : const Center(
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '로그인',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 1,
              ),

              //transition to sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("처음 방문하셨나요?  "),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                  GestureDetector(
                    onTap: navigateToSignup,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text(
                        "회원가입하기",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}