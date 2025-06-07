import 'package:flutter/material.dart';
import '../models/email.dart';

class EmailListItem extends StatelessWidget {
  final Email email;
  final VoidCallback? onTap;
  final Function(Email)? onToggleStar;

  const EmailListItem({
    super.key,
    required this.email,
    this.onTap,
    this.onToggleStar,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(email.subject),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (onTap != null) {
          onTap!();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${email.subject} moved to trash'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
              },
            ),
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Text(
            email.sender[0].toUpperCase(),
            style: const TextStyle(color: Colors.black87),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                email.sender,
                style: TextStyle(
                  fontWeight:
                      email.isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                email.isStarred ? Icons.star : Icons.star_border,
                color: email.isStarred ? Colors.amber : Colors.grey,
              ),
              onPressed: () {
                if (onToggleStar != null) {
                  onToggleStar!(email);
                }
              },
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              email.subject,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: email.isRead ? Colors.grey : Colors.black87,
                fontWeight: email.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            Text(
              email.content.length > 50
                  ? '${email.content.substring(0, 50)}...'
                  : email.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(_formatDate(email.timestamp),
                style: const TextStyle(fontSize: 12)),
            if (!email.isRead)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'New',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Failed to send':
        return Colors.red;
      case 'Sending...':
        return Colors.orange;
      case 'Sent':
        return Colors.green;
      case 'Scheduled':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}
