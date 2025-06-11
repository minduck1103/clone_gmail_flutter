import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/inbox_screen.dart';
import 'screens/compose_screen.dart';
import 'screens/email_detail_screen.dart';
import 'screens/login_screen.dart';
import 'screens/account_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/help_screen.dart';
import 'screens/feedback_screen.dart';
import 'services/email_service.dart';
import 'services/auth_service.dart';
import 'models/mail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EmailService()),
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Gmail Clone',
        theme: ThemeData(
          primarySwatch: Colors.red,
          useMaterial3: true,
        ),
        home: AuthOrInbox(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/inbox': (context) => const InboxScreen(),
          '/account': (context) => AccountScreen(),
          '/compose': (context) => const ComposeScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/change-password': (context) => const ChangePasswordScreen(),
          '/calendar': (context) => const CalendarScreen(),
          '/contacts': (context) => const ContactsScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/help': (context) => const HelpScreen(),
          '/feedback': (context) => const FeedbackScreen(),
          '/email': (context) {
            final mail = ModalRoute.of(context)!.settings.arguments as Mail;
            return EmailDetailScreen(mail: mail);
          },
        },
      ),
    );
  }
}

class AuthOrInbox extends StatelessWidget {
  const AuthOrInbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, _) {
        if (auth.isAuthenticated) {
          return const InboxScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
