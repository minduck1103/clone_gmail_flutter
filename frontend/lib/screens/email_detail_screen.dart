import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_html/flutter_html.dart';
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
                    child: Text(
                        (mail.senderName ?? mail.senderPhone)[0].toUpperCase()),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mail.senderName ?? mail.senderPhone,
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
              Html(
                data: mail.content,
                style: {
                  "body": Style(
                    fontSize: FontSize(16),
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                  "p": Style(
                    margin: Margins.only(bottom: 8),
                  ),
                },
              ),
              const SizedBox(height: 16),
              if (mail.attach.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Tệp đính kèm:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: mail.attach
                        .map((attachment) =>
                            _buildAttachmentItem(context, attachment))
                        .toList(),
                  ),
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

  Widget _buildAttachmentItem(BuildContext context, String attachment) {
    final fileName = attachment.split('/').last;

    // Extract display name from filename
    String displayName = fileName;

    // Remove timestamp prefix (format: timestamp-filename.ext)
    final timestampPattern = RegExp(r'^\d{13}-(.+)$');
    final match = timestampPattern.firstMatch(fileName);
    if (match != null) {
      displayName = match.group(1) ?? fileName;
    }

    // Try to decode URL-encoded filename
    try {
      displayName = Uri.decodeComponent(displayName);
    } catch (e) {
      // If decoding fails, use processed filename
    }

    // Replace underscores with spaces for better readability
    displayName = displayName.replaceAll('_', ' ');

    final baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:5000/api';
    final attachmentUrl = baseUrl.replaceAll('/api', '') + attachment;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(
            _getFileIcon(displayName),
            color: Colors.blue.shade600,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  'Tệp đính kèm',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.blue),
            onPressed: () =>
                _downloadAttachment(context, attachmentUrl, displayName),
            tooltip: 'Tải xuống',
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.attach_file;
    }
  }

  Future<void> _downloadAttachment(
      BuildContext context, String url, String fileName) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đang tải xuống $fileName...'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('Không thể mở URL: $url');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải tệp: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
