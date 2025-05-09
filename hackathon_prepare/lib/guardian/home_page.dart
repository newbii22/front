import 'package:flutter/material.dart';
import 'dart:async';

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
                child: Text(tprompt, style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
