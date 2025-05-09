import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('images/sju1.jpg'),
            SizedBox(height: 10),
            Image.network(
              'https://en.sejong.ac.kr/_res/sejong/eng/img/sejong_campus_en)240322.jpg',
            ),
          ],
        ),
      ),
    );
  }
}
