import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/inbox_screen.dart';
import 'screens/compose_screen.dart';
import 'screens/email_detail_screen.dart';
import 'services/email_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmailService(),
      child: MaterialApp(
        title: 'Gmail Clone',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const InboxScreen(),
          '/compose': (context) => const ComposeScreen(),
          '/email': (context) => const EmailDetailScreen(),
        },
      ),
    );
  }
}
