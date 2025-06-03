import 'package:flutter/material.dart';
import 'screens/settings_screen.dart';
import 'screens/feedback_screen.dart';

void main() {
  runApp(MyGmailCloneApp());
}

class MyGmailCloneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gmail UI Clone',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SettingsScreen(),
      routes: {
        '/feedback': (context) => FeedbackScreen(),
      },
    );
  }
}