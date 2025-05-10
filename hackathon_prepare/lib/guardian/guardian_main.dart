import 'package:flutter/material.dart';
import 'package:hackathon_prepare/guardian/guardian_notification.dart';
import 'package:hackathon_prepare/guardian/home_page.dart';
import 'package:hackathon_prepare/guardian/page2.dart';
import 'package:hackathon_prepare/guardian/page3.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Guardian extends StatelessWidget {
  const Guardian({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false, primarySwatch: Colors.lightGreen),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = [HomePage(), Page2(), Page3()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();  //뒤로가기가 정상적으로 작동하지 않음!!: MaterialApp()때문이라던데 음..
          },
          icon: Icon(Icons.arrow_back_ios),
        ),*/
        title: Text('위치 보기'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return GuardianNotification();
                  },
                ),
              );
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
          NavigationDestination(icon: Icon(Icons.add), label: 'Add'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
