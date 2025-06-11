import 'package:flutter/foundation.dart';
import 'api_service.dart';

class LabelService extends ChangeNotifier {
  final List<String> _labels = [];
  bool _isLoading = false;
  String? _error;

  List<String> get labels => List.unmodifiable(_labels);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchLabels() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getLabels();
      _labels.clear();
      _labels.addAll(response.cast<String>());
        } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLabel(String name) async {
    try {
      await ApiService.addLabel(name);
      if (!_labels.contains(name)) {
        _labels.add(name);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateLabel(String oldName, String newName) async {
    try {
      await ApiService.updateLabel(oldName, newName);
      final index = _labels.indexOf(oldName);
      if (index != -1) {
        _labels[index] = newName;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteLabel(String name) async {
    try {
      await ApiService.deleteLabel(name);
      _labels.remove(name);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addLabelToMail(String mailId, String labelName) async {
    try {
      await ApiService.addLabelToMail(mailId, labelName);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removeLabelFromMail(String mailId, String labelName) async {
    try {
      await ApiService.removeLabelFromMail(mailId, labelName);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<List<dynamic>> getMailsByLabel(String labelName) async {
    try {
      return await ApiService.getMailsByLabel(labelName);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
 