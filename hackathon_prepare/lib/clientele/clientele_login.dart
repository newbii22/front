import 'package:flutter/material.dart';
import 'package:hackathon_prepare/clientele/clientele_main.dart'; // Clientele() 화면 import
import 'package:hackathon_prepare/clientele/clientele_sign_up.dart'; // ClienteleSignUp() 화면 import
// import 'package:hackathon_prepare/kakao_login.dart'; // 필요시 주석 해제
// import 'package:hackathon_prepare/kakao_view_model.dart'; // 필요시 주석 해제
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hackathon_prepare/config/api_config.dart'; // ApiConfig.baseUrl 사용
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clientele App', // 앱 타이틀 변경
      home: ClienteleLogin(),
      routes: {
        '/signup': (context) => ClienteleSignUp(),
        '/main': (context) => Clientele(),
      },
    );
  }
}

class ClienteleLogin extends StatefulWidget {
  ClienteleLogin({super.key});

  @override
  State<ClienteleLogin> createState() => _ClienteleLoginState();
}

class _ClienteleLoginState extends State<ClienteleLogin> {
  String? apiResponse = '';
  bool _isLoading = false;

  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  Future<void> attemptLogin() async {
    if (_isLoading) return;

    if (!mounted) return;
    setState(() {
      _isLoading = true;
      apiResponse = '로그인 시도 중...';
    });

    final String id = idController.text;
    final String password = pwController.text;

    if (id.isEmpty) {
      if (!mounted) return;
      setState(() {
        apiResponse = 'ID를 입력해주세요.';
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(apiResponse!)));
      return;
    }

    String serverResponseStatus = '';
    try {
      final encodedId = Uri.encodeComponent(id);
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/check-safe?memberId=$encodedId'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("API Response Data: $data");
        String? message = data['message'] as String?;
        if (message == 'success') {
          serverResponseStatus = 'success';
        } else {
          serverResponseStatus = message ?? '로그인 실패: 서버 응답 메시지 없음';
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
        serverResponseStatus = '로그인 실패: 서버 오류 ${response.statusCode}';
      }
    } catch (e) {
      print('Error during API call: $e');
      serverResponseStatus = '로그인 중 오류 발생: $e';
    }

    if (!mounted) return;

    setState(() {
      apiResponse = serverResponseStatus;
      _isLoading = false;
    });

    if (serverResponseStatus == 'success') {
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(apiResponse ?? "알 수 없는 오류")));
    }
  }
  // final viewModel = KakaoLoginViewModel(KakaoLogin());
  // Future<void> signInWithKakao() async { ... }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientele Login'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Clientele();
                  },
                ),
              );
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'PW',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : attemptLogin,
                  child:
                      _isLoading
                          ? CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          )
                          : Text('Login'),
                ),
                SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ClienteleSignUp();
                        },
                      ),
                    );
                  },
                  child: Text('회원이 아니신가요? Sign Up'),
                ),
                SizedBox(height: 24),
                /*
                ElevatedButton(
                  onPressed: () {
                    // signInWithKakao();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                  child: Text('카카오 로그인'),
                ),
                */
                if (apiResponse != null &&
                    apiResponse!.isNotEmpty &&
                    !_isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      apiResponse!,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            apiResponse == 'success' ||
                                    (apiResponse != null &&
                                        apiResponse!.toLowerCase().contains(
                                          '성공',
                                        ))
                                ? Colors.green
                                : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
