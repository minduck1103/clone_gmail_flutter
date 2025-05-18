class Email {
  final String sender;
  final String subject;
  final String preview;
  final String time;
  final bool isRead;
  final bool isStarred;

  Email({
    required this.sender,
    required this.subject,
    required this.preview,
    required this.time,
    required this.isRead,
    required this.isStarred,
  });
}
