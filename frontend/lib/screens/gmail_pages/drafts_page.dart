import 'package:flutter/material.dart';
import '../../models/mail.dart';
import '../../widgets/email_item.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/email_action_bottom_sheet.dart';

class DraftsPage extends StatelessWidget {
  final List<Mail> emails;
  final Function(Mail) onEmailTap;
  final Function(Mail) onStarEmail;

  const DraftsPage({
    super.key,
    required this.emails,
    required this.onEmailTap,
    required this.onStarEmail,
  });

  @override
  Widget build(BuildContext context) {
    if (emails.isEmpty) {
      return const EmptyState(
        icon: Icons.drafts,
        title: 'Chưa có email nháp',
        message: 'Những email bạn soạn thảo nhưng chưa gửi sẽ được lưu ở đây.',
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
