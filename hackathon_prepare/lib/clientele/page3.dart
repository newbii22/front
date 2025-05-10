import 'package:hackathon_prepare/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // .env 파일 로드
  await dotenv.load(fileName: ".env");
  runApp(Page3());
}

class Page3 extends StatefulWidget {
  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  String? responseF = '';
  Future<void> pingServer() async {
    try {
      final prompt = Uri.encodeComponent(tprompt);
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/ping'), // 설정 파일의 baseUrl 사용
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data); // 예: { message: "pong" }
        String? message = data['message'] as String?;
        if (message != null) {
          setState(() {
            responseF = message;
          });
        } else {
          setState(() {
            responseF = 'response did not contain a message';
          });
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
        setState(() {
          responseF = 'reques failed';
        });
      }
    } catch (e) {
      print('Error during API call: $e');
      setState(() {
        responseF = 'error api call';
      });
    }
  }

  TextEditingController tcontroller = TextEditingController();
  String tprompt = '';
  Future<void> sendPrompt() async {
    setState(() {
      tprompt = tcontroller.text;
    });
    pingServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tcontroller,
              decoration: InputDecoration(
                labelText: 'Input',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: sendPrompt, child: Text('Send')),
            SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Text(responseF!, style: TextStyle(fontSize: 16)),
              ),
            ),
            /*
            FutureBuilder<String>(
              future: pingServer(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('Response: ${snapshot.data}');
                }
              },
            ),*/
          ],
        ),
      ),
    );
  }
}
