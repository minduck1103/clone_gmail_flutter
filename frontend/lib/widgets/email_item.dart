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
            email.senderPhone[0].toUpperCase(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                email.senderPhone,
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
            if (email.attach.isNotEmpty)
              const Icon(Icons.attachment, size: 16, color: Colors.grey),
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
}
