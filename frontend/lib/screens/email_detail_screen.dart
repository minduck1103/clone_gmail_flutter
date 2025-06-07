import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mail.dart';
import '../services/email_service.dart';
import 'compose_screen.dart';

class EmailDetailScreen extends StatelessWidget {
  final Mail mail;

  const EmailDetailScreen({
    super.key,
    required this.mail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mail.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showMoveToTrashDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Text(mail.senderPhone[0].toUpperCase()),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mail.senderPhone,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'To: ${mail.recipient.join(", ")}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatDate(mail.createdAt),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                mail.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mail.content,
                style: const TextStyle(fontSize: 16),
              ),
              if (mail.attach.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Attachments:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: mail.attach
                      .map((attachment) => Chip(
                            avatar: const Icon(Icons.attachment, size: 20),
                            label: Text(attachment.split('/').last),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              context,
              icon: Icons.reply,
              label: 'Trả lời',
              onPressed: () => _handleReply(context),
            ),
            _buildActionButton(
              context,
              icon: Icons.reply_all,
              label: 'Trả lời tất cả',
              onPressed: () => _handleReplyAll(context),
            ),
            _buildActionButton(
              context,
              icon: Icons.forward,
              label: 'Chuyển tiếp',
              onPressed: () => _handleForward(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoveToTrashDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chuyển vào thùng rác'),
          content:
              const Text('Bạn có chắc muốn chuyển email này vào thùng rác?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                final emailService = context.read<EmailService>();
                await emailService.moveToTrash(mail.id);

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã chuyển email vào thùng rác'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
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

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Icon(icon, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  void _handleReply(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComposeScreen(
          replyToEmail: mail,
          isReply: true,
        ),
      ),
    );
  }

  void _handleReplyAll(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComposeScreen(
          replyToEmail: mail,
          isReply: true,
          isReplyAll: true,
        ),
      ),
    );
  }

  void _handleForward(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComposeScreen(
          replyToEmail: mail,
          isForward: true,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
