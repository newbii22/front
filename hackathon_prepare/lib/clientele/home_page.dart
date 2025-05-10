import 'package:flutter/material.dart';
import 'dart:async';

import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController tcontroller = TextEditingController();

  String tprompt = '';

  Future<void> sendPrompt() async {
    setState(() {
      tprompt = tcontroller.text;
    });
  }

  String? latitude;
  String? longitude;
  String? statusMessage = "위치 정보 가져오는 중...";

  getGeoData() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          latitude = null;
          longitude = null;
          statusMessage = '위치 권한이 거부되었습니다.';
        });
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        latitude = null;
        longitude = null;
        statusMessage = '위치 권한이 영구적으로 거부되었습니다. 앱 설정에서 권한을 허용해주세요.';
      });
      return;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        latitude = null;
        longitude = null;
        statusMessage = '위치 서비스가 비활성화되어 있습니다. 활성화해주세요.';
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        statusMessage = null; // 성공 시 메시지 없음
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        latitude = null;
        longitude = null;
        statusMessage = '위치 정보를 가져오는 데 실패했습니다.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getGeoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /*
            TextField(
              controller: tcontroller,
              decoration: InputDecoration(
                labelText: 'Input',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: sendPrompt, child: Text('Send')),*/
            SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '위도: $latitude\n경도: $longitude \n $statusMessage',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
