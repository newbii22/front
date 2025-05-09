import 'package:flutter/material.dart';
import 'package:hackathon_prepare/guardian/guardian_main.dart';

class GuardianLogin extends StatefulWidget {
  GuardianLogin({super.key});

  @override
  State<GuardianLogin> createState() => _GuardianLoginState();
}

class _GuardianLoginState extends State<GuardianLogin> {
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
      appBar: AppBar(
        title: const Text('Guradian Login'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('Actions');
            },
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              ElevatedButton(onPressed: () {}, child: Text('Sign Up')),
            ],
          ),
        ),
      ),
    );
  }
}
