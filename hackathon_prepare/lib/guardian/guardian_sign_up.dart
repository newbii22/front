import 'package:flutter/material.dart';
import 'package:hackathon_prepare/guardian/guardian_main.dart';

class GuardianSignUp extends StatefulWidget {
  GuardianSignUp({super.key});

  @override
  State<GuardianSignUp> createState() => _GuardianSignUpState();
}

class _GuardianSignUpState extends State<GuardianSignUp> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String idPrompt = '';
  String pwPrompt = '';
  String namePrompt = '';

  Future<void> sendPrompt() async {
    setState(() {
      idPrompt = idController.text;
    });
    setState(() {
      pwPrompt = pwController.text;
    });
    setState(() {
      namePrompt = nameController.text;
    });
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
              SizedBox(height: 12),
              ElevatedButton(onPressed: sendPrompt, child: Text('Send')),
              SizedBox(height: 24),
              ElevatedButton(onPressed: () {}, child: Text('Sign Up')),
              Expanded(
                child: Column(
                  children: [
                    Text(idPrompt, style: TextStyle(fontSize: 16)),
                    Text(pwPrompt, style: TextStyle(fontSize: 16)),
                    Text(namePrompt, style: TextStyle(fontSize: 16)),
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
