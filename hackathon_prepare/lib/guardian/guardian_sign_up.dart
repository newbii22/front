import 'package:flutter/material.dart';
import 'package:hackathon_prepare/guardian/guardian_main.dart';
import 'package:kpostal/kpostal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hackathon_prepare/config/api_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // .env 파일 로드
  await dotenv.load(fileName: ".env");
  runApp(GuardianSignUp());
}

class GuardianSignUp extends StatefulWidget {
  GuardianSignUp({super.key});

  @override
  State<GuardianSignUp> createState() => _GuardianSignUpState();
}

class _GuardianSignUpState extends State<GuardianSignUp> {
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
      final LATprompt = Uri.encodeComponent(latitude);
      final LONGprompt = Uri.encodeComponent(longitude);
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/check-safe?memberId=${IDprompt}&latitude=${LATprompt}&longtitude=${LONGprompt}',
        ),
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
      ).showSnackBar(SnackBar(content: Text('Sign up failed: $responseF')));
    }
  }

  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String idPrompt = '';
  String pwPrompt = '';
  String namePrompt = '';

  String postCode = '-';
  String address = '-';
  String latitude = '-';
  String longitude = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';

  Future<void> sendPrompt() async {
    setState(() {
      idPrompt = idController.text;
      pwPrompt = pwController.text;
      namePrompt = nameController.text;
    });
    await pingServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guradian Sign Up'),
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
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => KpostalView(
                            useLocalServer: true,
                            localPort: 1024,
                            kakaoKey: ApiConfig.JSAppKey,
                            callback: (Kpostal result) {
                              setState(() {
                                this.postCode = result.postCode;
                                this.address = result.address;
                                this.latitude = result.latitude.toString();
                                this.longitude = result.longitude.toString();
                                this.kakaoLatitude =
                                    result.kakaoLatitude.toString();
                                this.kakaoLongitude =
                                    result.kakaoLongitude.toString();
                              });
                            },
                          ),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue,
                  ),
                ),
                child: Text(
                  'Search Address',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      'postCode',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('postCode: ${this.postCode}'),
                    Text(
                      'address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('address: ${this.address}'),
                    Text(
                      'LatLng',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'latitude: ${this.latitude} / longitude: ${this.longitude}',
                    ),
                    Text(
                      'through KAKAO Geocoder',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'latitude: ${this.kakaoLatitude} / longitude: ${this.kakaoLongitude}',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  sendPrompt();
                },
                child: Text('Sign Up'),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(idPrompt, style: TextStyle(fontSize: 16)),
                    Text(pwPrompt, style: TextStyle(fontSize: 16)),
                    Text(namePrompt, style: TextStyle(fontSize: 16)),
                    Text(responseF!, style: TextStyle(fontSize: 16)),
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
