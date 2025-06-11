import 'package:flutter/material.dart';
import '../models/email_thread.dart';
import '../models/mail.dart';

class EmailThreadItem extends StatelessWidget {
  final EmailThread thread;
  final VoidCallback onTap;
  final VoidCallback onStar;
  final VoidCallback? onLongPress;
  final bool isSelected;

  const EmailThreadItem({
    super.key,
    required this.thread,
    required this.onTap,
    required this.onStar,
    this.onLongPress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final latestEmail = thread.latestEmail;

    return GestureDetector(
      onLongPress: onLongPress,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Text(
            (latestEmail.senderName ?? latestEmail.senderPhone)[0]
                .toUpperCase(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      _getDisplaySender(),
                      style: TextStyle(
                        fontWeight: thread.hasUnread
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (thread.messageCount > 1)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${thread.messageCount}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Text(
              _formatTime(latestEmail.createdAt),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              thread.subject,
              style: TextStyle(
                fontWeight:
                    thread.hasUnread ? FontWeight.w500 : FontWeight.normal,
                color: thread.hasUnread ? Colors.black87 : Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              latestEmail.content,
              style: TextStyle(
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                if (thread.hasAttachments)
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.attachment, size: 16, color: Colors.grey),
                  ),
                // Ẩn hiển thị label
                // if (latestEmail.labels.isNotEmpty)
                //   Expanded(
                //     child: Wrap(
                //       spacing: 4,
                //       children: latestEmail.labels.take(3).map((label) {
                //         return Container(
                //           padding: const EdgeInsets.symmetric(
                //             horizontal: 6,
                //             vertical: 2,
                //           ),
                //           decoration: BoxDecoration(
                //             color: _getLabelColor(label).withOpacity(0.1),
                //             borderRadius: BorderRadius.circular(10),
                //             border: Border.all(
                //               color: _getLabelColor(label),
                //               width: 0.5,
                //             ),
                //           ),
                //           child: Row(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Icon(
                //                 _getLabelIcon(label),
                //                 size: 10,
                //                 color: _getLabelColor(label),
                //               ),
                //               const SizedBox(width: 2),
                //               Text(
                //                 label.length > 8
                //                     ? '${label.substring(0, 8)}...'
                //                     : label,
                //                 style: TextStyle(
                //                   fontSize: 10,
                //                   color: _getLabelColor(label),
                //                   fontWeight: FontWeight.w500,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         );
                //       }).toList(),
                //     ),
                //   ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            thread.isStarred ? Icons.star : Icons.star_border,
            color: thread.isStarred ? Colors.amber : Colors.grey,
          ),
          onPressed: onStar,
        ),
        selected: isSelected,
        selectedTileColor: Colors.grey[200],
        onTap: onTap,
      ),
    );
  }

  String _getDisplaySender() {
    if (thread.messageCount == 1) {
      return thread.latestEmail.senderName ?? thread.latestEmail.senderPhone;
    } else {
      // Hiển thị tất cả participants (for now show names from latest email)
      return thread.latestEmail.senderName ?? thread.latestEmail.senderPhone;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
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

  Color _getLabelColor(String label) {
    switch (label) {
      case 'Có gắn dấu sao':
        return Colors.orange;
      case 'Đã tạm ẩn':
        return Colors.purple;
      case 'Quan trọng':
        return Colors.red;
      case 'Đã gửi':
        return Colors.blue;
      case 'Đã lên lịch':
        return Colors.green;
      case 'Hộp thư đi':
        return Colors.teal;
      case 'Thư nháp':
        return Colors.grey;
      case 'Thùng rác':
        return Colors.red.shade800;
      case 'Spam':
        return Colors.deepOrange;
      case 'Tất cả thư':
        return Colors.indigo;
      default:
        return Colors.blue;
    }
  }
}
 