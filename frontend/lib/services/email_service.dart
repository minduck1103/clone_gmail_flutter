import 'package:flutter/foundation.dart';
import '../models/mail.dart';
import 'api_service.dart';

class EmailService extends ChangeNotifier {
  final List<Mail> _emails = [];
  bool _isLoading = false;
  String? _error;
  String? _currentPage;

  // Mail counts for different categories
  int _inboxCount = 0;
  int _sentCount = 0;
  int _draftCount = 0;
  int _starredCount = 0;
  int _trashCount = 0;
  int _allMailCount = 0;
  int _promotionsCount = 0;
  int _socialCount = 0;
  int _updatesCount = 0;
  int _importantCount = 0;
  int _snoozedCount = 0;
  int _scheduledCount = 0;
  int _outboxCount = 0;
  int _spamCount = 0;

  List<Mail> get emails => List.unmodifiable(_emails);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentPage => _currentPage;

  // Getters for mail counts
  int get inboxCount => _inboxCount;
  int get sentCount => _sentCount;
  int get draftCount => _draftCount;
  int get starredCount => _starredCount;
  int get trashCount => _trashCount;
  int get allMailCount => _allMailCount;
  int get promotionsCount => _promotionsCount;
  int get socialCount => _socialCount;
  int get updatesCount => _updatesCount;
  int get importantCount => _importantCount;
  int get snoozedCount => _snoozedCount;
  int get scheduledCount => _scheduledCount;
  int get outboxCount => _outboxCount;
  int get spamCount => _spamCount;

  // Method to fetch all mail counts
  Future<void> fetchAllMailCounts() async {
    try {
      // Fetch counts for each category in parallel
      await Future.wait([
        _fetchInboxCount(),
        _fetchSentCount(),
        _fetchDraftCount(),
        _fetchStarredCount(),
        _fetchTrashCount(),
        _fetchAllMailCount(),
        // Add other counts as needed
      ]);
      notifyListeners();
    } catch (e) {
      print('Error fetching mail counts: $e');
    }
  }

  Future<void> _fetchInboxCount() async {
    try {
      final response = await ApiService.getInboxMails();
      _inboxCount = response is List ? response.length : 0;
    } catch (e) {
      _inboxCount = 0;
    }
  }

  Future<void> _fetchSentCount() async {
    try {
      final response = await ApiService.getSentMails();
      _sentCount = response is List ? response.length : 0;
    } catch (e) {
      _sentCount = 0;
    }
  }

  Future<void> _fetchDraftCount() async {
    try {
      final response = await ApiService.getDraftMails();
      _draftCount = response is List ? response.length : 0;
    } catch (e) {
      _draftCount = 0;
    }
  }

  Future<void> _fetchStarredCount() async {
    try {
      final response = await ApiService.getStarredMails();
      _starredCount = response is List ? response.length : 0;
    } catch (e) {
      _starredCount = 0;
    }
  }

  Future<void> _fetchTrashCount() async {
    try {
      final response = await ApiService.getTrashedMails();
      _trashCount = response is List ? response.length : 0;
    } catch (e) {
      _trashCount = 0;
    }
  }

  Future<void> _fetchAllMailCount() async {
    try {
      final response = await ApiService.getAllMails();
      _allMailCount = response is List ? response.length : 0;
    } catch (e) {
      _allMailCount = 0;
    }
  }

  void addEmail(Mail email) {
    _emails.insert(0, email);
    // Update count based on current page
    switch (_currentPage) {
      case 'inbox':
        _inboxCount++;
        break;
      case 'sent':
        _sentCount++;
        break;
      case 'drafts':
        _draftCount++;
        break;
      case 'starred':
        _starredCount++;
        break;
      case 'trash':
        _trashCount++;
        break;
      case 'all':
        _allMailCount++;
        break;
    }
    notifyListeners();
  }

  void deleteEmail(String id) {
    _emails.removeWhere((email) => email.id == id);
    // Update count based on current page
    switch (_currentPage) {
      case 'inbox':
        _inboxCount = (_inboxCount - 1).clamp(0, double.infinity).toInt();
        break;
      case 'sent':
        _sentCount = (_sentCount - 1).clamp(0, double.infinity).toInt();
        break;
      case 'drafts':
        _draftCount = (_draftCount - 1).clamp(0, double.infinity).toInt();
        break;
      case 'starred':
        _starredCount = (_starredCount - 1).clamp(0, double.infinity).toInt();
        break;
      case 'trash':
        _trashCount = (_trashCount - 1).clamp(0, double.infinity).toInt();
        break;
      case 'all':
        _allMailCount = (_allMailCount - 1).clamp(0, double.infinity).toInt();
        break;
    }
    notifyListeners();
  }

  void clearEmails() {
    _emails.clear();
    _error = null;
    notifyListeners();
  }

  Future<void> fetchMailsByLabel(String label) async {
    _isLoading = true;
    _error = null;
    _currentPage = 'label_$label';
    notifyListeners();

    try {
      final response = await ApiService.getMailsByLabel(label);
      print('Raw response for label $label: ${response}');

      if (response is List) {
        final List<Mail> mappedEmails = response.map((json) {
          if (json is Map<String, dynamic>) {
            return Mail.fromJson(json);
          }
          throw Exception('Invalid mail data format');
        }).toList();

        _emails.clear();
        _emails.addAll(mappedEmails);
        print('Processed emails with label $label: ${_emails.length}');
      } else {
        _error = 'Invalid response format';
      }
    } catch (e) {
      print('Error fetching mails by label $label: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInboxMails() async {
    _isLoading = true;
    _error = null;
    _currentPage = 'inbox';
    notifyListeners();

    try {
      final response = await ApiService.getInboxMails();
      print('Raw response: ${response}');

      if (response is List) {
        final List<Mail> mappedEmails = response.map((json) {
          if (json is Map<String, dynamic>) {
            return Mail.fromJson(json);
          }
          throw Exception('Invalid mail data format');
        }).toList();

        _emails.clear();
        _emails.addAll(mappedEmails);
        _inboxCount = mappedEmails.length;
        print('Processed emails: ${_emails.length}');
      } else {
        _error = 'Invalid response format';
      }
    } catch (e) {
      print('Error fetching inbox: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSentMails() async {
    _isLoading = true;
    _error = null;
    _currentPage = 'sent';
    notifyListeners();

    try {
      final response = await ApiService.getSentMails();
      print('Raw sent mails response: $response');

      if (response is List) {
        final List<Mail> mappedEmails = response.map((json) {
          if (json is Map<String, dynamic>) {
            return Mail.fromJson(json);
          }
          throw Exception('Invalid mail data format');
        }).toList();

        _emails.clear();
        _emails.addAll(mappedEmails);
        _sentCount = mappedEmails.length;
        print('Processed sent emails: ${_emails.length}');
      } else {
        _error = 'Invalid response format';
      }
    } catch (e) {
      print('Error fetching sent mails: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDraftMails() async {
    _isLoading = true;
    _error = null;
    _currentPage = 'drafts';
    notifyListeners();

    try {
      final response = await ApiService.getDraftMails();
      print('Raw draft mails response: $response');

      if (response is List) {
        final List<Mail> mappedEmails = response.map((json) {
          if (json is Map<String, dynamic>) {
            return Mail.fromJson(json);
          }
          throw Exception('Invalid mail data format');
        }).toList();

        _emails.clear();
        _emails.addAll(mappedEmails);
        _draftCount = mappedEmails.length;
        print('Processed draft emails: ${_emails.length}');
      } else {
        _error = 'Invalid response format';
      }
    } catch (e) {
      print('Error fetching draft mails: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTrashedMails() async {
    _isLoading = true;
    _error = null;
    _currentPage = 'trash';
    notifyListeners();

    try {
      final response = await ApiService.getTrashedMails();
      print('Raw trash mails response: $response');

      if (response is List) {
        final List<Mail> mappedEmails = response.map((json) {
          if (json is Map<String, dynamic>) {
            return Mail.fromJson(json);
          }
          throw Exception('Invalid mail data format');
        }).toList();

        _emails.clear();
        _emails.addAll(mappedEmails);
        _trashCount = mappedEmails.length;
        print('Processed trash emails: ${_emails.length}');
      } else {
        _error = 'Invalid response format';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStarredMails() async {
    _isLoading = true;
    _error = null;
    _currentPage = 'starred';
    notifyListeners();

    try {
      final response = await ApiService.getStarredMails();
      print('Raw starred mails response: $response');

      if (response is List) {
        final List<Mail> mappedEmails = response.map((json) {
          if (json is Map<String, dynamic>) {
            return Mail.fromJson(json);
          }
          throw Exception('Invalid mail data format');
        }).toList();

        _emails.clear();
        _emails.addAll(mappedEmails);
        _starredCount = mappedEmails.length;
        print('Processed starred emails: ${_emails.length}');
      } else {
        _error = 'Invalid response format';
      }
    } catch (e) {
      print('Error fetching starred mails: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllMails() async {
    _isLoading = true;
    _error = null;
    _currentPage = 'all';
    notifyListeners();

    try {
      final response = await ApiService.getAllMails();
      print('Raw all mails response: $response');

      if (response is List) {
        final List<Mail> mappedEmails = response.map((json) {
          if (json is Map<String, dynamic>) {
            return Mail.fromJson(json);
          }
          throw Exception('Invalid mail data format');
        }).toList();

        _emails.clear();
        _emails.addAll(mappedEmails);
        _allMailCount = mappedEmails.length;
        print('Processed all emails: ${_emails.length}');
      } else {
        _error = 'Invalid response format';
      }
    } catch (e) {
      print('Error fetching all mails: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String id, {bool? isRead}) async {
    try {
      final index = _emails.indexWhere((email) => email.id == id);
      if (index != -1) {
        final currentEmail = _emails[index];
        final newReadState = isRead ?? true;

        // Optimistically update UI
        _emails[index] = currentEmail.copyWith(isRead: newReadState);
        notifyListeners();

        // Call API to update backend
        await ApiService.toggleRead(id, newReadState);
      }
    } catch (e) {
      // Revert the optimistic update on error
      final index = _emails.indexWhere((email) => email.id == id);
      if (index != -1) {
        final currentEmail = _emails[index];
        _emails[index] = currentEmail.copyWith(isRead: !(isRead ?? true));
        notifyListeners();
      }
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleStarred(String id) async {
    try {
      final index = _emails.indexWhere((email) => email.id == id);
      if (index != -1) {
        final currentEmail = _emails[index];
        final newStarredState = !currentEmail.isStarred;

        // Optimistically update UI
        _emails[index] = currentEmail.copyWith(isStarred: newStarredState);
        notifyListeners();

        // Call API to update backend
        await ApiService.toggleStarred(id, newStarredState);
        print('Successfully toggled star for email $id to $newStarredState');
      }
    } catch (e) {
      print('Error toggling star: $e');
      // Revert the optimistic update on error
      final index = _emails.indexWhere((email) => email.id == id);
      if (index != -1) {
        final currentEmail = _emails[index];
        _emails[index] =
            currentEmail.copyWith(isStarred: !currentEmail.isStarred);
        notifyListeners();
      }
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAsStarred(String id) async {
    try {
      final index = _emails.indexWhere((email) => email.id == id);
      if (index != -1) {
        _emails[index] =
            _emails[index].copyWith(isStarred: !_emails[index].isStarred);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> moveToTrash(String id) async {
    try {
      await ApiService.toggleTrash(id, true);

      // Remove from current list only if not in trash page
      if (_currentPage != 'trash') {
        _emails.removeWhere((email) => email.id == id);
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteMail(String id) async {
    try {
      await ApiService.deleteMail(id);

      // Remove from current list
      _emails.removeWhere((email) => email.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> replyToMail(String id, String content) async {
    try {
      final response = await ApiService.replyMail(id, content);

      // Refresh emails after reply
      if (_currentPage != null) {
        switch (_currentPage) {
          case 'inbox':
            await fetchInboxMails();
            break;
          case 'sent':
            await fetchSentMails();
            break;
          default:
            await fetchInboxMails();
        }
      }

      return response;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<Map<String, dynamic>> forwardMail(
      String id, List<String> recipients, String content) async {
    try {
      final response = await ApiService.forwardMail(id, recipients, content);

      // Refresh emails after forward
      if (_currentPage != null) {
        switch (_currentPage) {
          case 'inbox':
            await fetchInboxMails();
            break;
          case 'sent':
            await fetchSentMails();
            break;
          default:
            await fetchInboxMails();
        }
      }

      return response;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateLabels(String id, List<String> labels) async {
    try {
      final index = _emails.indexWhere((email) => email.id == id);
      if (index != -1) {
        final currentEmail = _emails[index];

        // Optimistically update UI
        _emails[index] = currentEmail.copyWith(labels: labels);
        notifyListeners();

        // Call API to update backend
        await ApiService.updateLabels(id, labels);
        print('Successfully updated labels for email $id: $labels');
      }
    } catch (e) {
      print('Error updating labels: $e');
      // Revert the optimistic update on error
      final index = _emails.indexWhere((email) => email.id == id);
      if (index != -1) {
        final currentEmail = _emails[index];
        _emails[index] = currentEmail.copyWith(labels: currentEmail.labels);
        notifyListeners();
      }
      _error = e.toString();
      notifyListeners();
    }
  }
}
