import 'package:flutter/material.dart';
import '../../models/mail.dart';
import '../../widgets/email_item.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/email_action_bottom_sheet.dart';

class PrimaryPage extends StatelessWidget {
  final List<Mail> emails;
  final Function(Mail) onEmailTap;
  final Function(Mail) onStarEmail;
  final String? error;

  const PrimaryPage({
    super.key,
    required this.emails,
    required this.onEmailTap,
    required this.onStarEmail,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (error != null && error!.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              'Đã xảy ra lỗi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red.shade500,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (emails.isEmpty) {
      return const EmptyState(
        icon: Icons.inbox,
        title: 'Hộp thư trống',
        message:
            'Bạn chưa có email nào trong hộp thư chính.\nHãy kiểm tra lại sau.',
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
