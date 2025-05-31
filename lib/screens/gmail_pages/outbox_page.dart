import 'package:flutter/material.dart';
import '../../models/email.dart';
import '../../widgets/email_item.dart';

class OutboxPage extends StatelessWidget {
  final List<Email> emails;
  final Function(Email) onEmailTap;
  final Function(Email) onStarEmail;

  const OutboxPage({
    super.key,
    required this.emails,
    required this.onEmailTap,
    required this.onStarEmail,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: emails.length,
      itemBuilder: (context, index) {
        final email = emails[index];
        return EmailItem(
          email: email,
          onTap: () => onEmailTap(email),
          onStar: () => onStarEmail(email),
        );
      },
    );
  }
}
