import 'package:flutter/material.dart';
import '../../widgets/email_item.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/email_action_bottom_sheet.dart';
import '../../models/mail.dart';

class AllMailPage extends StatelessWidget {
  final List<Mail> emails;
  final Function(Mail) onEmailTap;
  final Function(Mail) onStarEmail;

  const AllMailPage({
    super.key,
    required this.emails,
    required this.onEmailTap,
    required this.onStarEmail,
  });

  @override
  Widget build(BuildContext context) {
    if (emails.isEmpty) {
      return const EmptyState(
        icon: Icons.all_inbox,
        title: 'Chưa có email nào',
        message: 'Tất cả email từ mọi nhãn sẽ xuất hiện ở đây.',
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
