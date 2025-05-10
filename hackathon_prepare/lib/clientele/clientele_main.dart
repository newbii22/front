import 'package:flutter/material.dart';
import 'package:hackathon_prepare/clientele/home_page.dart';
import 'package:hackathon_prepare/clientele/page2.dart';
import 'package:hackathon_prepare/clientele/page3.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Clientele extends StatelessWidget {
  const Clientele({super.key});

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
      appBar: AppBar(title: Text('Clientele')),
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
          //NavigationDestination(icon: Icon(Icons.add), label: 'Add'),
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
