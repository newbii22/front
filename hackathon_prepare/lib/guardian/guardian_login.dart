import 'package:flutter/material.dart';
import 'package:hackathon_prepare/guardian/guardian_main.dart';
import 'package:hackathon_prepare/guardian/guardian_sign_up.dart';
import 'package:hackathon_prepare/kakao_login.dart';
import 'package:hackathon_prepare/kakao_view_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hackathon_prepare/config/api_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // .env 파일 로드
  await dotenv.load(fileName: ".env");
  runApp(GuardianLogin());
}

class GuardianLogin extends StatefulWidget {
  GuardianLogin({super.key});

  @override
  State<GuardianLogin> createState() => _GuardianLoginState();
}

class _GuardianLoginState extends State<GuardianLogin> {
  String? responseF = '';
  bool _isLoading = false;

  Future<void> pingServer() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      responseF = '서버 응답 기다리는 중...';
    });

    String localResponseF = '';
    try {
      final IDprompt = Uri.encodeComponent(idPrompt);
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/check-safe?memberId=${IDprompt}'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data); // 예: { message: "pong" }
        String? message = data['message'] as String?;
        if (message != null) {
          localResponseF = message;
        } else {
          localResponseF = 'Response did not contain a message';
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
        localResponseF = 'Request failed: ${response.statusCode}';
      }
    } catch (e) {
      print('Error during API call: $e');
      localResponseF = 'Error during API call';
    }

    if (!mounted) return;

    setState(() {
      responseF = localResponseF;
      _isLoading = false; // 로딩 종료
    });

    if (responseF == 'success') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return Guardian();
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $responseF')));
    }
  }

  final viewModel = KakaoLoginViewModel(KakaoLogin());

  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  String idPrompt = '';
  String pwPrompt = '';

  Future<void> sendPrompt() async {
    setState(() {
      idPrompt = idController.text;
      pwPrompt = pwController.text;
    });
    await pingServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guradian Login'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: pwController,
                decoration: InputDecoration(
                  labelText: 'PW',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(onPressed: sendPrompt, child: Text('Send')),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Guardian();
                      },
                    ),
                  );
                },
                child: Text('Sign In'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return GuardianSignUp();
                      },
                    ),
                  );
                },
                child: Text('Sign Up'),
              ),

              Expanded(
                child: Column(
                  children: [
                    Text(idPrompt, style: TextStyle(fontSize: 16)),
                    Text(pwPrompt, style: TextStyle(fontSize: 16)),
                    Text(responseF!, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              /*
              Expanded(
                child: ListView(
                  children: [
                    if (viewModel
                            .user
                            ?.kakaoAccount
                            ?.profile
                            ?.profileImageUrl !=
                        null)
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(
                          viewModel
                                  .user
                                  ?.kakaoAccount
                                  ?.profile
                                  ?.profileImageUrl ??
                              '',
                        ),
                      ),
                    Center(
                      child: Text(
                        viewModel.user?.kakaoAccount?.profile?.nickname ?? '',
                        style: const TextStyle(fontSize: 36.0),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (viewModel.user == null) {
                          await viewModel.login();
                        } else {
                          await viewModel.logout();
                        }
                        setState(() {
                          // 로그인 / 로그아웃 후에 화면 갱신
                        });
                      },
                      child: Text(
                        viewModel.user == null ? '카카오 로그인' : '카카오 로그아웃',
                      ),
                    ),
                  ],
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
