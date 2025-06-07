import 'package:flutter/foundation.dart';
import '../models/mail.dart';
import 'api_service.dart';

class EmailService extends ChangeNotifier {
  final List<Mail> _emails = [];
  bool _isLoading = false;
  String? _error;
  String? _currentPage;

  List<Mail> get emails => List.unmodifiable(_emails);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentPage => _currentPage;

  void addEmail(Mail email) {
    _emails.insert(0, email);
    notifyListeners();
  }

  void deleteEmail(String id) {
    _emails.removeWhere((email) => email.id == id);
    notifyListeners();
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
}
