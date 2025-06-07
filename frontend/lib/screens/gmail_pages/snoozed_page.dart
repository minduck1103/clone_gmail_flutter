import 'package:flutter/material.dart';
import '../../models/mail.dart';
import '../../widgets/email_item.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/email_action_bottom_sheet.dart';

class SnoozedPage extends StatelessWidget {
  final List<Mail> emails;
  final Function(Mail) onEmailTap;
  final Function(Mail) onStarEmail;

  const SnoozedPage({
    super.key,
    required this.emails,
    required this.onEmailTap,
    required this.onStarEmail,
  });

  @override
  Widget build(BuildContext context) {
    if (emails.isEmpty) {
      return const EmptyState(
        icon: Icons.snooze,
        title: 'Chưa có email đã tạm ẩn',
        message:
            'Những email bạn tạm ẩn sẽ xuất hiện lại ở đây vào thời gian đã định.',
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
