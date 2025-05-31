import 'package:flutter/foundation.dart';
import '../models/email.dart';

class EmailService extends ChangeNotifier {
  final List<Email> _emails = [
    Email(
      id: '1',
      sender: 'John Doe',
      subject: 'Meeting Tomorrow',
      content: 'Hi, let\'s meet tomorrow at 10 AM...',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
      isStarred: false,
    ),
    Email(
      id: '2',
      sender: 'Alice Smith',
      subject: 'Project Update',
      content: 'Here\'s the latest update on the project...',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      isStarred: true,
    ),
  ];

  List<Email> get emails => _emails;

  void addEmail(Email email) {
    _emails.add(email);
    notifyListeners();
  }

  void markAsRead(String emailId) {
    final index = _emails.indexWhere((email) => email.id == emailId);
    if (index != -1) {
      _emails[index] = _emails[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void toggleStar(String emailId) {
    final index = _emails.indexWhere((email) => email.id == emailId);
    if (index != -1) {
      _emails[index] = _emails[index].copyWith(
        isStarred: !_emails[index].isStarred,
      );
      notifyListeners();
    }
  }
}
