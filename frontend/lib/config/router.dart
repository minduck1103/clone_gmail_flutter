import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/inbox_screen.dart';
import '../screens/compose_screen.dart';
import '../screens/email_detail_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const InboxScreen()),
    GoRoute(
      path: '/compose',
      builder: (context, state) => const ComposeScreen(),
    ),
    GoRoute(
      path: '/email-detail',
      builder: (context, state) => const EmailDetailScreen(),
    ),
  ],
);
