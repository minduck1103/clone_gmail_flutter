import 'package:flutter/material.dart';
import '../models/email.dart';

class EmailItem extends StatelessWidget {
  final Email email;
  final VoidCallback onTap;
  final VoidCallback onStar;
  final bool isSelected;

  const EmailItem({
    super.key,
    required this.email,
    required this.onTap,
    required this.onStar,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Text(
          email.sender[0].toUpperCase(),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              email.sender,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _formatTime(email.timestamp),
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
            email.subject,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
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
