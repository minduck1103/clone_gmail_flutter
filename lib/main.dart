import 'package:flutter/material.dart';
import 'package:gmail_app/screens/feedback_screen.dart';
import 'package:gmail_app/screens/settings_screen.dart';
import 'screens/inbox_screen.dart';
import 'screens/promotions_screen.dart';
import 'screens/social_screen.dart';
import 'screens/update_screen.dart';
import 'screens/starred_screen.dart';
import 'screens/snoozed_screen.dart';
import 'screens/important_screen.dart';
import 'screens/sent_screen.dart';
import 'screens/scheduled_screen.dart';
import 'screens/outbox_screen.dart';
import 'screens/drafts_screen.dart';
import 'screens/all_mail_screen.dart';
import 'screens/spam_screen.dart';
import 'screens/trash_screen.dart';
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
      routes: {
        '/inbox': (context) => const InboxScreen(),
        '/promotions': (context) => const PromotionsScreen(),
        '/social': (context) => const SocialScreen(),
        '/update': (context) => const UpdateScreen(),
        '/starred': (context) => const StarredScreen(),
        '/snoozed': (context) => const SnoozedScreen(),
        '/important': (context) => const ImportantScreen(),
        '/sent': (context) => const SentScreen(),
        '/scheduled': (context) => const ScheduledScreen(),
        '/outbox': (context) => const OutboxScreen(),
        '/drafts': (context) => const DraftsScreen(),
        '/allmail': (context) => const AllMailScreen(),
        '/spam': (context) => const SpamScreen(),
        '/trash': (context) => const TrashScreen(),
        '/feedback': (context) => FeedbackScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
      
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
