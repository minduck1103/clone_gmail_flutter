import 'package:flutter/material.dart';
import '../../models/mail.dart';
import '../../widgets/email_item.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/email_action_bottom_sheet.dart';

class StarredPage extends StatelessWidget {
  final List<Mail> emails;
  final Function(Mail) onEmailTap;
  final Function(Mail) onStarEmail;

  const StarredPage({
    super.key,
    required this.emails,
    required this.onEmailTap,
    required this.onStarEmail,
  });

  @override
  Widget build(BuildContext context) {
    if (emails.isEmpty) {
      return const EmptyState(
        icon: Icons.star_outline,
        title: 'Chưa có email đã gắn sao',
        message:
            'Gắn sao cho những email quan trọng để dễ dàng tìm lại sau này.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: emails.length,
      itemBuilder: (context, index) {
        final email = emails[index];
        return EmailItem(
          email: email,
          onTap: () => onEmailTap(email),
          onStar: () => onStarEmail(email),
          onLongPress: () => EmailActionBottomSheet.show(context, email),
        );
      },
    );
  }
}
