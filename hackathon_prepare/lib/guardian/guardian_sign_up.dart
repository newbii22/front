import 'package:flutter/material.dart';
import 'package:hackathon_prepare/guardian/guardian_login.dart';
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

  TextEditingController postCodeController = TextEditingController();
  TextEditingController adressController = TextEditingController();

  Future<void> sendPrompt() async {
    setState(() {
      idPrompt = idController.text;
      pwPrompt = pwController.text;
      namePrompt = nameController.text;
    });

    //await pingServer();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return GuardianLogin();
        },
      ),
    );
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
                obscureText: true,
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
              SizedBox(height: 12),
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      readOnly: true,
                      controller: postCodeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "우편번호",
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => KpostalView(
                                  useLocalServer: true,
                                  localPort: 1024,
                                  kakaoKey: ApiConfig.JSAppKey,
                                  callback: (Kpostal result) {
                                    postCodeController.text = result.postCode;
                                    adressController.text = result.address;
                                    setState(() {
                                      this.postCode = result.postCode;
                                      this.address = result.address;
                                      this.latitude =
                                          result.latitude.toString();
                                      this.longitude =
                                          result.longitude.toString();
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
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      readOnly: true,
                      controller: adressController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "주소",
                      ),
                    ),
                  ],
                ),
              ),

              /*
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
              ),*/
              //SizedBox(height: 12),
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

/*
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hackathon_prepare/config/api_config.dart';
// import 'package:hackathon_prepare/guardian/guardian_main.dart'; // 화면 전환 없으므로 주석 처리 또는 삭제
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kpostal/kpostal.dart';

// --- main.dart 역할을 하는 부분 ---
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Could not load .env file (this is optional if not used): $e");
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guardian Sign Up App',
      home: GuardianSignUp(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// --- main.dart 역할 끝 ---

class GuardianSignUp extends StatefulWidget {
  GuardianSignUp({super.key});

  @override
  State<GuardianSignUp> createState() => _GuardianSignUpState();
}

class _GuardianSignUpState extends State<GuardianSignUp> {
  String? apiCallResponseMessage;
  bool _isLoading = false;

  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressDetailController = TextEditingController();

  String postCode = '';
  String address = '';
  String latitude = '';
  String longitude = '';
  // kakaoLatitude, kakaoLongitude는 필요에 따라 UI에 표시할 수 있음

  // API 호출 후 받은 회원 정보를 저장할 상태 변수
  Map<String, dynamic>? _memberInfoFromApi;

  Future<void> fetchOrUpdateMemberInfo() async {
    // 함수 이름 변경
    if (_isLoading) return;
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      apiCallResponseMessage = '회원 정보 처리 중...';
      _memberInfoFromApi = null; // 이전 정보 초기화
    });

    final String currentId = idController.text;
    final String currentPw = pwController.text;
    final String currentName = nameController.text;

    if (currentId.isEmpty) {
      if (!mounted) return;
      setState(() {
        apiCallResponseMessage = 'ID를 입력해주세요.';
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(apiCallResponseMessage!)));
      return;
    }

    if (address.isEmpty || latitude.isEmpty || longitude.isEmpty) {
      if (!mounted) return;
      setState(() {
        apiCallResponseMessage = '주소 검색을 통해 주소 및 좌표를 설정해주세요.';
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(apiCallResponseMessage!)));
      return;
    }

    Map<String, dynamic> commandPayload = {
      "id": currentId,
      "email": "$currentId@example.com", // 실제 이메일 처리 필요
      "role": "GUARDIAN",
      "name": currentName,
      "birth": "2000-01-01", // 실제 생년월일 처리 필요
      "phone": "010-0000-0000", // 실제 전화번호 처리 필요
      "userId": currentId,
      "password": currentPw,
      "address": address,
      "latitude": double.tryParse(latitude) ?? 0.0,
      "longitude": double.tryParse(longitude) ?? 0.0,
    };

    String serverResponseStatus = ''; // 'success' 또는 오류 메시지

    try {
      String commandJsonString = jsonEncode(commandPayload);
      // API 엔드포인트는 첨부해주신 이미지 기준 /api/members/getMemberInfo
      // 만약 실제 회원 가입 API가 다르다면 해당 URL로 변경해야 합니다.
      final Uri url = Uri.parse(
        '${ApiConfig.baseUrl}/api/members/getMemberInfo',
      ).replace(queryParameters: {'command': commandJsonString});

      print('Request URL: $url');
      print('Command Payload (Query): $commandJsonString');

      final response = await http.post(
        url,
        headers: {
          // 필요한 헤더
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          try {
            final data = jsonDecode(response.body);
            print("API Response Data: $data");
            // API 응답이 회원 정보 객체라고 가정 (첨부 이미지의 Responses 참고)
            _memberInfoFromApi = data as Map<String, dynamic>;
            // 성공 여부 판단 (예: 응답받은 ID와 요청 ID가 같은지)
            if (_memberInfoFromApi!.containsKey('id') &&
                _memberInfoFromApi!['id'] == currentId) {
              serverResponseStatus = 'success';
              apiCallResponseMessage = '회원 정보가 성공적으로 처리되었습니다.';
            } else {
              serverResponseStatus = '정보 처리 실패: 반환된 ID 불일치';
              apiCallResponseMessage = serverResponseStatus;
              _memberInfoFromApi = null; // 실패 시 이전 정보 지우기
            }
          } catch (e) {
            print("Could not parse JSON response: ${response.body}");
            serverResponseStatus = '정보 처리 성공 (응답 형식 확인 필요)';
            apiCallResponseMessage = serverResponseStatus;
            _memberInfoFromApi = {
              'rawResponse': response.body,
            }; // 파싱 실패 시 원본 저장
          }
        } else {
          // 200 OK지만 본문이 없는 경우
          serverResponseStatus = '정보 처리 성공 (서버 응답 내용 없음)';
          apiCallResponseMessage = serverResponseStatus;
          _memberInfoFromApi = {'message': '서버로부터 내용 없는 성공 응답'};
        }
      } else {
        print(
          'Request failed with status: ${response.statusCode}. Body: ${response.body}',
        );
        serverResponseStatus = '정보 처리 실패: 서버 오류 ${response.statusCode}';
        apiCallResponseMessage = serverResponseStatus;
        if (response.body.isNotEmpty) {
          try {
            final errorData = jsonDecode(response.body);
            apiCallResponseMessage =
                '$apiCallResponseMessage\nError: ${errorData['message'] ?? response.body}';
          } catch (_) {
            apiCallResponseMessage =
                '$apiCallResponseMessage\n${response.body}';
          }
        }
      }
    } catch (e) {
      print('Error during API call: $e');
      serverResponseStatus = '정보 처리 중 오류 발생: $e';
      apiCallResponseMessage = serverResponseStatus;
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      // apiCallResponseMessage은 이미 위에서 setState 내부 또는 외부에서 설정됨
    });

    // 화면 전환 로직은 제거 (하나의 파일에서 처리)
    if (serverResponseStatus == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(apiCallResponseMessage ?? '성공적으로 처리되었습니다!')),
      );
      // 여기서 추가적인 UI 변경이나 작업 수행 가능 (예: 입력 필드 초기화)
      // idController.clear();
      // pwController.clear();
      // nameController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(apiCallResponseMessage ?? "알 수 없는 오류로 처리에 실패했습니다."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardian Sign Up / Info'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    labelText: 'Password',
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
                SizedBox(height: 12),
                // 주소 및 좌표 표시
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('우편번호: $postCode', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      Text('주소: $address', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      Text('위도: $latitude', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      Text('경도: $longitude', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    Kpostal? result = await Navigator.push(
                      // KpostalView 결과가 nullable일 수 있음
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
                                });
                              },
                            ),
                      ),
                    );
                    if (result != null && mounted) {
                      // 결과가 null이 아니고 위젯이 마운트된 상태인지 확인
                      setState(() {
                        postCode = result.postCode;
                        address = result.address;
                        latitude =
                            result.latitude?.toString() ?? ''; // Nullable 처리
                        longitude =
                            result.longitude?.toString() ?? ''; // Nullable 처리
                      });
                    }
                  },
                  child: Text('주소 검색'),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : fetchOrUpdateMemberInfo,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                  ),
                  child:
                      _isLoading
                          ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3.0,
                            ),
                          )
                          : Text('회원 정보 처리 (Sign Up / Get Info)'),
                ),
                SizedBox(height: 12),
                // API 응답 메시지 또는 조회된 정보 표시
                if (_isLoading) // 로딩 중 메시지
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      apiCallResponseMessage ?? "처리 중...",
                      textAlign: TextAlign.center,
                    ),
                  )
                else if (apiCallResponseMessage != null &&
                    apiCallResponseMessage!.isNotEmpty) // 처리 완료 후 메시지
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      apiCallResponseMessage!,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            apiCallResponseMessage!.toLowerCase().contains(
                                      '성공',
                                    ) ||
                                    apiCallResponseMessage!
                                        .toLowerCase()
                                        .contains('success')
                                ? Colors.green
                                : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // API를 통해 성공적으로 받아온 회원 정보 표시 (선택 사항)
                if (_memberInfoFromApi != null &&
                    !_isLoading &&
                    (apiCallResponseMessage?.toLowerCase().contains('성공') ==
                            true ||
                        apiCallResponseMessage?.toLowerCase().contains(
                              'success',
                            ) ==
                            true))
                  Card(
                    margin: EdgeInsets.only(top: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "처리된 회원 정보:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text("ID: ${_memberInfoFromApi!['id'] ?? 'N/A'}"),
                          Text("Name: ${_memberInfoFromApi!['name'] ?? 'N/A'}"),
                          Text(
                            "Email: ${_memberInfoFromApi!['email'] ?? 'N/A'}",
                          ),
                          Text("Role: ${_memberInfoFromApi!['role'] ?? 'N/A'}"),
                          Text(
                            "Birth: ${_memberInfoFromApi!['birth'] ?? 'N/A'}",
                          ),
                          Text(
                            "Phone: ${_memberInfoFromApi!['phone'] ?? 'N/A'}",
                          ),
                          // 비밀번호는 보통 응답에 포함되지 않으므로 표시하지 않음
                        ],
                      ),
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
*/
