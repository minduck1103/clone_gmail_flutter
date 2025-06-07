import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mail.dart';
import '../services/email_service.dart';
import '../screens/compose_screen.dart';

class EmailActionBottomSheet extends StatelessWidget {
  final Mail email;

  const EmailActionBottomSheet({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Text(
                    email.senderPhone[0].toUpperCase(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        email.senderPhone,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(),

          // Actions
          _buildActionTile(
            context,
            icon: Icons.reply,
            title: 'Trả lời',
            onTap: () => _handleReply(context),
          ),

          _buildActionTile(
            context,
            icon: Icons.forward,
            title: 'Chuyển tiếp',
            onTap: () => _handleForward(context),
          ),

          _buildActionTile(
            context,
            icon:
                email.isRead ? Icons.mark_email_unread : Icons.mark_email_read,
            title: email.isRead ? 'Đánh dấu chưa đọc' : 'Đánh dấu đã đọc',
            onTap: () => _handleToggleRead(context),
          ),

          _buildActionTile(
            context,
            icon: email.isStarred ? Icons.star_border : Icons.star,
            title: email.isStarred ? 'Bỏ gắn sao' : 'Gắn sao',
            onTap: () => _handleToggleStar(context),
          ),

          _buildActionTile(
            context,
            icon: Icons.delete_outline,
            title: 'Chuyển vào thùng rác',
            onTap: () => _handleMoveToTrash(context),
            isDestructive: true,
          ),

          _buildActionTile(
            context,
            icon: Icons.delete_forever,
            title: 'Xóa vĩnh viễn',
            onTap: () => _handleDelete(context),
            isDestructive: true,
          ),

          _buildActionTile(
            context,
            icon: Icons.label_outline,
            title: 'Quản lý nhãn',
            onTap: () => _handleManageLabels(context),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.grey.shade700,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _handleReply(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComposeScreen(
          replyToEmail: email,
          isReply: true,
        ),
      ),
    );
  }

  void _handleForward(BuildContext context) {
    // Navigate to compose screen with forward data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ComposeScreen(),
      ),
    );
  }

  void _handleToggleRead(BuildContext context) {
    final emailService = context.read<EmailService>();
    emailService.markAsRead(email.id, isRead: !email.isRead);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(email.isRead ? 'Đã đánh dấu chưa đọc' : 'Đã đánh dấu đã đọc'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleToggleStar(BuildContext context) {
    final emailService = context.read<EmailService>();
    emailService.toggleStarred(email.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(email.isStarred ? 'Đã bỏ gắn sao' : 'Đã gắn sao'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleMoveToTrash(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content:
              const Text('Bạn có chắc muốn chuyển email này vào thùng rác?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                final emailService = context.read<EmailService>();
                emailService.moveToTrash(email.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã chuyển email vào thùng rác'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Chuyển vào thùng rác',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _handleDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text(
              'Bạn có chắc muốn xóa vĩnh viễn email này? Hành động này không thể hoàn tác.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                final emailService = context.read<EmailService>();
                emailService.deleteMail(email.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa email vĩnh viễn'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Xóa vĩnh viễn',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _handleManageLabels(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng quản lý nhãn sẽ được cập nhật'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static void show(BuildContext context, Mail email) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: EmailActionBottomSheet(email: email),
      ),
    );
  }
}
