import 'package:flutter/material.dart';

enum EmailStatus {
  sending,
  sent,
  failed,
  scheduled,
  trash,
  spam,
  draft;

  Color get color {
    switch (this) {
      case EmailStatus.failed:
        return Colors.red;
      case EmailStatus.sending:
        return Colors.orange;
      case EmailStatus.sent:
        return Colors.green;
      case EmailStatus.scheduled:
        return Colors.blue;
      case EmailStatus.draft:
        return Colors.grey.shade600;
      case EmailStatus.trash:
      case EmailStatus.spam:
        return Colors.grey;
    }
  }

  String get displayText {
    switch (this) {
      case EmailStatus.sending:
        return 'Sending...';
      case EmailStatus.sent:
        return 'Sent';
      case EmailStatus.failed:
        return 'Failed to send';
      case EmailStatus.scheduled:
        return 'Scheduled';
      case EmailStatus.draft:
        return 'Draft';
      case EmailStatus.trash:
        return 'Trash';
      case EmailStatus.spam:
        return 'Spam';
    }
  }
}

class Email {
  final String id;
  final String sender;
  final String subject;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final bool isStarred;

  Email({
    required this.id,
    required this.sender,
    required this.subject,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.isStarred = false,
  });

  Email copyWith({
    String? id,
    String? sender,
    String? subject,
    String? content,
    DateTime? timestamp,
    bool? isRead,
    bool? isStarred,
  }) {
    return Email(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isStarred: isStarred ?? this.isStarred,
    );
  }
}
