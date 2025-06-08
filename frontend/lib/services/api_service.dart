import 'dart:convert';
import 'package:http/http.dart' as http; // Mail APIs
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/mail.dart';

class ApiService {
  static String get baseUrl =>
      dotenv.env['API_URL'] ?? 'http://localhost:5000/api';
  static String? _token;

  static Future<String?> getToken() async {
    if (_token == null) {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      print(
          'Retrieved token from SharedPreferences: ${_token?.substring(0, 10)}...');
    }
    return _token;
  }

  static Map<String, String> get _headers {
    if (_token == null) {
      print('Warning: No token available in headers');
    }
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  static Future<Map<String, dynamic>> login(
      String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: json.encode({
          'phone': phone,
          'password': password,
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Đăng nhập thất bại');
      }
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> register(
      String phone, String fullname, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _headers,
        body: json.encode({
          'phone': phone,
          'fullname': fullname,
          'password': password,
        }),
      );

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Đăng ký thất bại');
      }
    } catch (e) {
      print('Register error: $e');
      rethrow;
    }
  }

  // Mail APIs
  static Future<List<dynamic>> getInboxMails() async {
    try {
      final token = await getToken();
      print('Fetching inbox mails...');
      print('Using token: ${token?.substring(0, 10)}...');

      final response = await http.get(
        Uri.parse('$baseUrl/mail/user/inbox'),
        headers: _headers,
      );

      print('Inbox response status: ${response.statusCode}');
      if (response.statusCode == 404) {
        // Không có mail, trả về mảng rỗng
        print('No inbox mails found, returning empty list');
        return [];
      }
      if (response.statusCode != 200) {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to load inbox mails: ${response.statusCode} - ${response.reasonPhrase}');
      }

      final data = json.decode(response.body);
      final mails = data is List ? data : [];
      print('Fetched ${mails.length} inbox mails');
      return mails;
    } catch (e) {
      print('Error fetching inbox mails: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> getSentMails() async {
    try {
      await getToken();
      print('Fetching sent mails...');

      final response = await http.get(
        Uri.parse('$baseUrl/mail/user/sent'),
        headers: _headers,
      );

      if (response.statusCode == 404) {
        // Không có mail, trả về mảng rỗng
        print('No sent mails found, returning empty list');
        return [];
      }
      if (response.statusCode != 200) {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to load sent mails: ${response.statusCode} - ${response.reasonPhrase}');
      }

      final data = json.decode(response.body);
      final mails = data is List ? data : [];
      print('Fetched ${mails.length} sent mails');
      return mails;
    } catch (e) {
      print('Error fetching sent mails: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> getDraftMails() async {
    try {
      await getToken();
      print('Fetching draft mails...');

      final response = await http.get(
        Uri.parse('$baseUrl/mail/user/drafts'),
        headers: _headers,
      );

      print('Draft mails response status: ${response.statusCode}');
      if (response.statusCode == 404) {
        // Không có mail, trả về mảng rỗng
        print('No draft mails found, returning empty list');
        return [];
      }
      if (response.statusCode != 200) {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to load draft mails: ${response.statusCode} - ${response.reasonPhrase}');
      }

      final data = json.decode(response.body);
      final mails = data is List ? data : [];
      print('Fetched ${mails.length} draft mails');
      return mails;
    } catch (e) {
      print('Error fetching draft mails: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> getTrashedMails() async {
    try {
      await getToken();
      print('Fetching trash mails...');

      final response = await http.get(
        Uri.parse('$baseUrl/mail/user/trash'),
        headers: _headers,
      );

      print('Trash mails response status: ${response.statusCode}');
      if (response.statusCode == 404) {
        // Không có mail, trả về mảng rỗng
        print('No trash mails found, returning empty list');
        return [];
      }
      if (response.statusCode != 200) {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to load trashed mails: ${response.statusCode} - ${response.reasonPhrase}');
      }

      final data = json.decode(response.body);
      final mails = data is List ? data : [];
      print('Fetched ${mails.length} trash mails');
      return mails;
    } catch (e) {
      print('Error fetching trash mails: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> getStarredMails() async {
    try {
      await getToken();
      print('Fetching starred mails...');

      final response = await http.get(
        Uri.parse('$baseUrl/mail/user/starred'),
        headers: _headers,
      );

      print('Starred mails response status: ${response.statusCode}');
      if (response.statusCode == 404) {
        // Không có mail, trả về mảng rỗng
        print('No starred mails found, returning empty list');
        return [];
      }
      if (response.statusCode != 200) {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to load starred mails: ${response.statusCode} - ${response.reasonPhrase}');
      }

      final data = json.decode(response.body);
      final mails = data is List ? data : [];
      print('Fetched ${mails.length} starred mails');
      return mails;
    } catch (e) {
      print('Error fetching starred mails: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> getAllMails() async {
    try {
      await getToken();
      print('Fetching all mails...');

      final response = await http.get(
        Uri.parse('$baseUrl/mail/user/all'),
        headers: _headers,
      );

      print('All mails response status: ${response.statusCode}');
      if (response.statusCode == 404) {
        // Không có mail, trả về mảng rỗng
        print('No all mails found, returning empty list');
        return [];
      }
      if (response.statusCode != 200) {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to load all mails: ${response.statusCode} - ${response.reasonPhrase}');
      }

      final data = json.decode(response.body);
      final mails = data is List ? data : [];
      print('Fetched ${mails.length} all mails');
      return mails;
    } catch (e) {
      print('Error fetching all mails: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> getMailsByLabel(String label) async {
    try {
      await getToken();
      print('Fetching mails with label: $label');

      final response = await http.get(
        Uri.parse('$baseUrl/mail/user/label/${Uri.encodeComponent(label)}'),
        headers: _headers,
      );

      print('Mails by label response status: ${response.statusCode}');
      if (response.statusCode == 404) {
        // Không có mail với label này, trả về mảng rỗng
        print('No mails found with label $label, returning empty list');
        return [];
      }
      if (response.statusCode != 200) {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to load mails by label: ${response.statusCode} - ${response.reasonPhrase}');
      }

      final data = json.decode(response.body);
      final mails = data is List ? data : [];
      print('Fetched ${mails.length} mails with label: $label');
      return mails;
    } catch (e) {
      print('Error fetching mails by label: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getMailById(String id) async {
    try {
      await getToken();
      print('Fetching mail with ID: $id');

      final response = await http.get(
        Uri.parse('$baseUrl/mail/$id'),
        headers: _headers,
      );

      print('Get mail by ID response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to load mail: ${response.statusCode} - ${response.reasonPhrase}');
      }

      final data = json.decode(response.body);
      print('Successfully fetched mail details');
      return data;
    } catch (e) {
      print('Error fetching mail by ID: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createMail(
      Map<String, dynamic> mailData) async {
    try {
      await getToken();
      print('Creating new mail with data: $mailData');

      final response = await http.post(
        Uri.parse('$baseUrl/mail'),
        headers: _headers,
        body: json.encode({
          ...mailData,
          'senderPhone': '', // Will be set by backend from token
          'createdBy': '', // Will be set by backend from token
          'createdAt': DateTime.now().toIso8601String(),
        }),
      );

      print('Create mail response status: ${response.statusCode}');
      if (response.statusCode != 201) {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to create mail: ${response.statusCode} - ${response.reasonPhrase}');
      }

      final data = json.decode(response.body);
      print('Successfully created mail: ${data['message']}');
      return data;
    } catch (e) {
      print('Error creating mail: $e');
      rethrow;
    }
  }

  // Label APIs
  static Future<List<dynamic>> getLabels() async {
    await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/label'),
      headers: _headers,
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> addLabel(String name) async {
    await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/label'),
      headers: _headers,
      body: json.encode({'name': name}),
    );
    return json.decode(response.body);
  }

  // User APIs
  static Future<Map<String, dynamic>> getUserAccount() async {
    await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/account'),
      headers: _headers,
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> updateUserAccount(
      Map<String, dynamic> data) async {
    await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/user/account'),
      headers: _headers,
      body: json.encode(data),
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getUserPreferences() async {
    await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/preferences'),
      headers: _headers,
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> updateUserPreferences(
      Map<String, dynamic> preferences) async {
    await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/user/preferences'),
      headers: _headers,
      body: json.encode(preferences),
    );
    return json.decode(response.body);
  }

  // Mail actions
  static Future<Map<String, dynamic>> toggleStarred(
      String mailId, bool isStarred) async {
    try {
      await getToken();
      print('Toggling star for mail $mailId to $isStarred');

      final response = await http.patch(
        Uri.parse('$baseUrl/mail/$mailId/star'),
        headers: _headers,
        body: json.encode({'isStarred': isStarred}),
      );

      print('Toggle star response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to toggle star: ${response.statusCode} - ${response.reasonPhrase}');
      }

      final data = json.decode(response.body);
      print('Successfully toggled star');
      return data;
    } catch (e) {
      print('Error toggling star: $e');
      rethrow;
    }
  }

  // Auth APIs còn thiếu
  static Future<Map<String, dynamic>> logout() async {
    try {
      await getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: _headers,
      );
      print('Logout response status: ${response.statusCode}');
      return json.decode(response.body);
    } catch (e) {
      print('Error logout: $e');
      return {'message': 'Logout failed'};
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone}),
      );
      print('Forgot password response status: ${response.statusCode}');
      return json.decode(response.body);
    } catch (e) {
      print('Error forgot password: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> resetPassword(
      String token, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password/$token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'password': newPassword}),
      );
      print('Reset password response status: ${response.statusCode}');
      return json.decode(response.body);
    } catch (e) {
      print('Error reset password: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updatePassword(
      String currentPassword, String newPassword) async {
    try {
      await getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/auth/update-password'),
        headers: _headers,
        body: json.encode({
          'password': currentPassword,
          'newPassword': newPassword,
        }),
      );
      print('Update password response status: ${response.statusCode}');
      print('Update password response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Cập nhật mật khẩu thất bại');
      }
    } catch (e) {
      print('Error update password: $e');
      rethrow;
    }
  }

  // User APIs còn thiếu
  static Future<Map<String, dynamic>> uploadAvatar(String imagePath) async {
    try {
      await getToken();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/user/avatar'),
      );

      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }

      request.files.add(await http.MultipartFile.fromPath('avatar', imagePath));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('Upload avatar response status: ${response.statusCode}');
      return json.decode(responseBody);
    } catch (e) {
      print('Error upload avatar: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> toggle2FA() async {
    try {
      await getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/user/2fa'),
        headers: _headers,
      );
      print('Toggle 2FA response status: ${response.statusCode}');
      return json.decode(response.body);
    } catch (e) {
      print('Error toggle 2FA: $e');
      rethrow;
    }
  }

  // Mail APIs còn thiếu
  static Future<Map<String, dynamic>> updateMail(
      String mailId, Map<String, dynamic> mailData) async {
    try {
      await getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/mail/$mailId'),
        headers: _headers,
        body: json.encode(mailData),
      );
      print('Update mail response status: ${response.statusCode}');
      return json.decode(response.body);
    } catch (e) {
      print('Error update mail: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> deleteMail(String mailId) async {
    try {
      await getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/mail/$mailId'),
        headers: _headers,
      );
      print('Delete mail response status: ${response.statusCode}');
      return json.decode(response.body);
    } catch (e) {
      print('Error delete mail: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> toggleRead(
      String mailId, bool isRead) async {
    try {
      await getToken();
      final response = await http.patch(
        Uri.parse('$baseUrl/mail/$mailId/read'),
        headers: _headers,
        body: json.encode({'isRead': isRead}),
      );
      print('Toggle read response status: ${response.statusCode}');
      return json.decode(response.body);
    } catch (e) {
      print('Error toggle read: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> toggleTrash(
      String mailId, bool isTrashed) async {
    try {
      await getToken();
      final response = await http.patch(
        Uri.parse('$baseUrl/mail/$mailId/trash'),
        headers: _headers,
        body: json.encode({'isTrashed': isTrashed}),
      );
      print('Toggle trash response status: ${response.statusCode}');
      return json.decode(response.body);
    } catch (e) {
      print('Error toggle trash: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> replyMail(
      String mailId, String content) async {
    try {
      await getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/mail/$mailId/reply'),
        headers: _headers,
        body: json.encode({'content': content}),
      );
      print('Reply mail response status: ${response.statusCode}');
      return json.decode(response.body);
    } catch (e) {
      print('Error reply mail: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> forwardMail(
      String mailId, List<String> recipient, String content) async {
    try {
      await getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/mail/$mailId/forward'),
        headers: _headers,
        body: json.encode({
          'recipient': recipient,
          'content': content,
        }),
      );
      print('Forward mail response status: ${response.statusCode}');
      return json.decode(response.body);
    } catch (e) {
      print('Error forward mail: $e');
      rethrow;
    }
  }

  // Label APIs còn thiếu
  static Future<Map<String, dynamic>> updateLabel(
      String oldName, String newName) async {
    try {
      await getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/label'),
        headers: _headers,
        body: json.encode({
          'oldName': oldName,
          'newName': newName,
        }),
      );
      print('Update label response status: ${response.statusCode}');
      return json.decode(response.body);
    } catch (e) {
      print('Error update label: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> deleteLabel(String name) async {
    try {
      await getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/label'),
        headers: _headers,
        body: json.encode({'name': name}),
      );
      print('Delete label response status: ${response.statusCode}');
      return json.decode(response.body);
    } catch (e) {
      print('Error delete label: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> addLabelToMail(
      String mailId, String labelName) async {
    try {
      await getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/label/mail/$mailId'),
        headers: _headers,
        body: json.encode({'name': labelName}),
      );
      print('Add label to mail response status: ${response.statusCode}');
      return json.decode(response.body);
    } catch (e) {
      print('Error add label to mail: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> removeLabelFromMail(
      String mailId, String labelName) async {
    try {
      await getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/label/mail/$mailId'),
        headers: _headers,
        body: json.encode({'name': labelName}),
      );
      print('Remove label from mail response status: ${response.statusCode}');
      return json.decode(response.body);
    } catch (e) {
      print('Error remove label from mail: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateLabels(
      String mailId, List<String> labels) async {
    try {
      await getToken();
      final response = await http.patch(
        Uri.parse('$baseUrl/mail/$mailId/labels'),
        headers: _headers,
        body: json.encode({'labels': labels}),
      );
      print('Update labels response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Failed to update labels: ${response.statusCode}');
      }
      return json.decode(response.body);
    } catch (e) {
      print('Error update labels: $e');
      rethrow;
    }
  }
}
