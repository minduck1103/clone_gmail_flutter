import 'package:flutter/material.dart';
import '../../models/mail.dart';
import '../../widgets/email_item.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/email_action_bottom_sheet.dart';

class LabelPage extends StatelessWidget {
  final List<Mail> emails;
  final String labelName;
  final Function(Mail) onEmailTap;
  final Function(Mail) onStarEmail;
  final String? error;

  const LabelPage({
    super.key,
    required this.emails,
    required this.labelName,
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

    // Filter emails by label
    final filteredEmails = emails.where((email) {
      return email.labels != null && email.labels!.contains(labelName);
    }).toList();

    if (filteredEmails.isEmpty) {
      return EmptyState(
        icon: _getLabelIcon(labelName),
        title: 'Không có email nào',
        message:
            'Chưa có email nào với nhãn "$labelName".\nHãy kiểm tra lại sau.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredEmails.length,
      itemBuilder: (context, index) {
        final email = filteredEmails[index];
        return EmailItem(
          email: email,
          onTap: () => onEmailTap(email),
          onStar: () => onStarEmail(email),
          onLongPress: () => EmailActionBottomSheet.show(context, email),
        );
      },
    );
  }

  IconData _getLabelIcon(String label) {
    switch (label) {
      case 'Có gắn dấu sao':
        return Icons.star;
      case 'Đã tạm ẩn':
        return Icons.snooze;
      case 'Quan trọng':
        return Icons.label_important;
      case 'Đã gửi':
        return Icons.send;
      case 'Đã lên lịch':
        return Icons.schedule_send;
      case 'Hộp thư đi':
        return Icons.outbox;
      case 'Thư nháp':
        return Icons.drafts;
      case 'Thùng rác':
        return Icons.delete;
      case 'Spam':
        return Icons.report;
      case 'Tất cả thư':
        return Icons.mail;
      default:
        return Icons.label;
    }
  }
}
