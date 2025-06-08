import 'mail.dart';

class EmailThread {
  final String subject;
  final List<Mail> emails;
  final Mail latestEmail;
  final int messageCount;
  final bool hasUnread;
  final List<String> participants;

  EmailThread({
    required this.subject,
    required this.emails,
    required this.latestEmail,
    required this.messageCount,
    required this.hasUnread,
    required this.participants,
  });

  factory EmailThread.fromEmails(List<Mail> emails) {
    if (emails.isEmpty) {
      throw ArgumentError('Emails list cannot be empty');
    }

    // Sắp xếp emails theo thời gian tăng dần
    emails.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final latestEmail = emails.last;
    final hasUnread = emails.any((email) => !email.isRead);

    // Thu thập tất cả participants
    final Set<String> participantSet = {};
    for (final email in emails) {
      participantSet.add(email.senderPhone);
      participantSet.addAll(email.recipient);
    }

    return EmailThread(
      subject: latestEmail.title,
      emails: emails,
      latestEmail: latestEmail,
      messageCount: emails.length,
      hasUnread: hasUnread,
      participants: participantSet.toList(),
    );
  }

  // Lấy subject chuẩn hóa (loại bỏ Re:, Fwd:)
  static String normalizeSubject(String subject) {
    return subject
        .replaceAll(RegExp(r'^(Re:\s*|Fwd:\s*)+', caseSensitive: false), '')
        .trim();
  }

  // Group emails thành threads
  static List<EmailThread> groupEmailsIntoThreads(List<Mail> emails) {
    final Map<String, List<Mail>> subjectGroups = {};

    for (final email in emails) {
      final normalizedSubject = normalizeSubject(email.title);
      subjectGroups.putIfAbsent(normalizedSubject, () => []).add(email);
    }

    return subjectGroups.values
        .map((emailGroup) => EmailThread.fromEmails(emailGroup))
        .toList()
      ..sort(
          (a, b) => b.latestEmail.createdAt.compareTo(a.latestEmail.createdAt));
  }

  bool get isStarred => emails.any((email) => email.isStarred);

  bool get hasAttachments => emails.any((email) => email.attach.isNotEmpty);
}
