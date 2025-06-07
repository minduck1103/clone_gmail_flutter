import 'package:flutter/material.dart';
import '../../models/mail.dart';
import '../../widgets/email_item.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/email_action_bottom_sheet.dart';

class UpdatesPage extends StatelessWidget {
  final List<Mail> emails;
  final Function(Mail) onEmailTap;
  final Function(Mail) onStarEmail;

  const UpdatesPage({
    super.key,
    required this.emails,
    required this.onEmailTap,
    required this.onStarEmail,
  });

  @override
  Widget build(BuildContext context) {
    if (emails.isEmpty) {
      return const EmptyState(
        icon: Icons.info_outline,
        title: 'Chưa có email cập nhật',
        message:
            'Những email thông báo cập nhật từ các dịch vụ sẽ xuất hiện ở đây.',
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
