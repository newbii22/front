import 'package:flutter/material.dart';
import 'package:hackathon_prepare/clientele/clientele_main.dart';
import 'package:hackathon_prepare/clientele/clientele_sign_up.dart';
import 'package:hackathon_prepare/kakao_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:hackathon_prepare/kakao_view_model.dart';

class ClienteleLogin extends StatefulWidget {
  ClienteleLogin({super.key});

  @override
  State<ClienteleLogin> createState() => _ClienteleLoginState();
}

class _ClienteleLoginState extends State<ClienteleLogin> {
  final viewModel = KakaoLoginViewModel(KakaoLogin());

  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  String idPrompt = '';
  String pwPrompt = '';

  Future<void> sendPrompt() async {
    setState(() {
      idPrompt = idController.text;
    });
    setState(() {
      pwPrompt = pwController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientele Login'),
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
              /*
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
              SizedBox(height: 24),*/
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Clientele();
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
                        return ClienteleSignUp();
                      },
                    ),
                  );
                },
                child: Text('Sign Up'),
              ),

              /*
              Expanded(
                child: Column(
                  children: [
                    Text(idPrompt, style: TextStyle(fontSize: 16)),
                    Text(pwPrompt, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),*/
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
