import 'package:flutter/material.dart';

class GuardianNotification extends StatefulWidget {
  const GuardianNotification({super.key});

  @override
  State<GuardianNotification> createState() => _GuardianNotificationState();
}

final List<String> entries = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G', 'F', 'H', 'I'];

class _GuardianNotificationState extends State<GuardianNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            final reversedIndex = entries.length-1-index;
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: ListTile(
                leading: Icon(Icons.notifications_active),
                title: Text(entries[reversedIndex]),
                subtitle: Text('@@@ 님이 &&&에 있습니다 \n (2025-05-10, 10:23)'),
              ),
            );
          }
      ),
    );
  }
}


