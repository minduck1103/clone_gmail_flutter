import 'package:flutter/material.dart';
import 'screens/inbox_screen.dart';

void main() {
  runApp(const GmailCloneApp());
}

class GmailCloneApp extends StatelessWidget {
  const GmailCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gmail Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.red,
          onPrimary: Colors.white,
          secondary: Colors.red.shade700,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey.shade700,
        ),
      ),
      home: const InboxScreen(),
    );
  }
}
