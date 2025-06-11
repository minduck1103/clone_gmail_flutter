import 'package:flutter/material.dart';
import '../models/mail.dart';

class EmailItem extends StatelessWidget {
  final Mail email;
  final VoidCallback onTap;
  final VoidCallback onStar;
  final VoidCallback? onLongPress;
  final bool isSelected;

  const EmailItem({
    super.key,
    required this.email,
    required this.onTap,
    required this.onStar,
    this.onLongPress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Text(
            (email.senderName ?? email.senderPhone)[0].toUpperCase(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                email.senderName ?? email.senderPhone,
                style: TextStyle(
                  fontWeight:
                      email.isRead ? FontWeight.normal : FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              _formatTime(email.createdAt),
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
              email.title,
              style: TextStyle(
                fontWeight: email.isRead ? FontWeight.normal : FontWeight.w500,
                color: email.isRead ? Colors.grey[600] : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              email.content,
              style: TextStyle(
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
            if (email.attach.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.attachment, size: 16, color: Colors.grey),
                  ),
                // Ẩn hiển thị label
                // if (email.labels != null && email.labels!.isNotEmpty)
                //   Expanded(
                //     child: Wrap(
                //       spacing: 4,
                //       children: email.labels!.take(3).map((label) {
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
            email.isStarred ? Icons.star : Icons.star_border,
            color: email.isStarred ? Colors.amber : Colors.grey,
          ),
          onPressed: onStar,
        ),
        selected: isSelected,
        selectedTileColor: Colors.grey[200],
        onTap: onTap,
      ),
    );
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
