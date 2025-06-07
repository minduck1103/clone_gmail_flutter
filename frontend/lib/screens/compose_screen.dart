import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../services/api_service.dart';
import '../services/email_service.dart';
import '../models/mail.dart';

class ComposeScreen extends StatefulWidget {
  final Mail? replyToEmail;
  final bool isReply;
  final bool isReplyAll;
  final bool isForward;

  const ComposeScreen({
    super.key,
    this.replyToEmail,
    this.isReply = false,
    this.isReplyAll = false,
    this.isForward = false,
  });

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final _toController = TextEditingController();
  final _ccController = TextEditingController();
  final _bccController = TextEditingController();
  final _subjectController = TextEditingController();
  final _contentController = TextEditingController();

  bool _showCcBcc = false;
  bool _isSending = false;
  List<PlatformFile> _attachments = [];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.replyToEmail != null) {
      if (widget.isReply) {
        if (widget.isReplyAll) {
          // Reply all - include all recipients
          List<String> allRecipients = [widget.replyToEmail!.senderPhone];
          allRecipients.addAll(widget.replyToEmail!.recipient);
          allRecipients.removeWhere((recipient) => recipient.isEmpty);
          _toController.text = allRecipients.join(', ');
        } else {
          // Reply only to sender
          _toController.text = widget.replyToEmail!.senderPhone;
        }
        _subjectController.text = widget.replyToEmail!.title.startsWith('Re: ')
            ? widget.replyToEmail!.title
            : 'Re: ${widget.replyToEmail!.title}';
        _contentController.text =
            '\n\n--- Original Message ---\nFrom: ${widget.replyToEmail!.senderPhone}\nSubject: ${widget.replyToEmail!.title}\n\n${widget.replyToEmail!.content}';
      } else if (widget.isForward) {
        _subjectController.text = widget.replyToEmail!.title.startsWith('Fwd: ')
            ? widget.replyToEmail!.title
            : 'Fwd: ${widget.replyToEmail!.title}';
        _contentController.text =
            '\n\n--- Forwarded Message ---\nFrom: ${widget.replyToEmail!.senderPhone}\nTo: ${widget.replyToEmail!.recipient.join(', ')}\nSubject: ${widget.replyToEmail!.title}\n\n${widget.replyToEmail!.content}';
      }
    }
  }

  @override
  void dispose() {
    _toController.dispose();
    _ccController.dispose();
    _bccController.dispose();
    _subjectController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        setState(() {
          _attachments.addAll(result.files);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã thêm ${result.files.length} tệp đính kèm'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi chọn tệp: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{10,11}$');
    return phoneRegex.hasMatch(phone.trim());
  }

  List<String> _parsePhones(String phoneString) {
    if (phoneString.trim().isEmpty) return [];

    return phoneString
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  String? _validatePhones(String phoneString, String fieldName) {
    final phones = _parsePhones(phoneString);
    if (phones.isEmpty) return null;

    for (String phone in phones) {
      if (!_isValidPhone(phone)) {
        return '$fieldName chứa số điện thoại không hợp lệ: $phone';
      }
    }
    return null;
  }

  Future<void> _sendEmail() async {
    // Validation
    if (_toController.text.trim().isEmpty) {
      _showError('Vui lòng nhập người nhận');
      return;
    }

    if (_subjectController.text.trim().isEmpty) {
      _showError('Vui lòng nhập chủ đề');
      return;
    }

    if (_contentController.text.trim().isEmpty) {
      _showError('Vui lòng nhập nội dung email');
      return;
    }

    // Validate phone numbers
    String? toError = _validatePhones(_toController.text, 'Người nhận');
    if (toError != null) {
      _showError(toError);
      return;
    }

    String? ccError = _validatePhones(_ccController.text, 'CC');
    if (ccError != null) {
      _showError(ccError);
      return;
    }

    String? bccError = _validatePhones(_bccController.text, 'BCC');
    if (bccError != null) {
      _showError(bccError);
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // Prepare attachments data
      List<Map<String, dynamic>> attachData = [];
      for (var file in _attachments) {
        attachData.add({
          'filename': file.name,
          'size': file.size,
          'type': file.extension ?? 'unknown',
        });
      }

      final emailData = {
        'recipient': _parsePhones(_toController.text),
        'title': _subjectController.text.trim(),
        'content': _contentController.text.trim(),
        'autoSave': false,
        'isRead': true,
        'isStarred': false,
        'labels': [],
        'isTrashed': false,
        'cc': _parsePhones(_ccController.text),
        'bcc': _parsePhones(_bccController.text),
        'attach': attachData,
      };

      final response = await ApiService.createMail(emailData);

      if (response['message'] == 'Mail created successfully') {
        if (mounted) {
          // Refresh email list
          context.read<EmailService>().fetchInboxMails();
          context.read<EmailService>().fetchSentMails();

          Navigator.pop(context);
          _showSuccess('Email đã được gửi thành công!');
        }
      } else {
        throw Exception('Không thể gửi email');
      }
    } catch (e) {
      _showError('Lỗi khi gửi email: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveDraft() async {
    try {
      final draftData = {
        'recipient': _parsePhones(_toController.text),
        'title': _subjectController.text.trim().isEmpty
            ? '(Không có chủ đề)'
            : _subjectController.text.trim(),
        'content': _contentController.text.trim(),
        'autoSave': true,
        'isRead': false,
        'isStarred': false,
        'labels': [],
        'isTrashed': false,
        'cc': _parsePhones(_ccController.text),
        'bcc': _parsePhones(_bccController.text),
        'attach': [],
      };

      await ApiService.createMail(draftData);

      if (mounted) {
        context.read<EmailService>().fetchDraftMails();
        Navigator.pop(context);
        _showSuccess('Thư nháp đã được lưu');
      }
    } catch (e) {
      _showError('Lỗi khi lưu thư nháp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Soạn thư',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.black54),
            onPressed: _pickFiles,
            tooltip: 'Đính kèm tệp',
          ),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black54),
            onPressed: _saveDraft,
            tooltip: 'Lưu thư nháp',
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: _isSending ? null : _sendEmail,
              icon: _isSending
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send, size: 18),
              label: Text(_isSending ? 'Đang gửi...' : 'Gửi'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.blue.withOpacity(0.1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Email fields container
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        // To field
                        _buildEmailField(
                          controller: _toController,
                          label: 'Đến',
                          hintText: 'Nhập số điện thoại người nhận',
                          isRequired: true,
                        ),

                        // CC/BCC toggle and fields
                        if (!_showCcBcc)
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _showCcBcc = true;
                                });
                              },
                              child: Text(
                                '+ CC/BCC',
                                style: TextStyle(color: Colors.blue.shade600),
                              ),
                            ),
                          ),

                        if (_showCcBcc) ...[
                          _buildEmailField(
                            controller: _ccController,
                            label: 'CC',
                            hintText: 'Số điện thoại CC (tùy chọn)',
                          ),
                          _buildEmailField(
                            controller: _bccController,
                            label: 'BCC',
                            hintText: 'Số điện thoại BCC (tùy chọn)',
                          ),
                        ],

                        // Subject field
                        _buildEmailField(
                          controller: _subjectController,
                          label: 'Chủ đề',
                          hintText: 'Nhập chủ đề email',
                          isRequired: true,
                        ),

                        const Divider(height: 1, color: Colors.grey),
                      ],
                    ),
                  ),

                  // Attachments section
                  if (_attachments.isNotEmpty)
                    Container(
                      color: Colors.grey.shade50,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tệp đính kèm (${_attachments.length})',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _attachments.asMap().entries.map((entry) {
                              int index = entry.key;
                              PlatformFile file = entry.value;
                              return Chip(
                                avatar: Icon(
                                  _getFileIcon(file.extension),
                                  size: 18,
                                  color: Colors.blue.shade600,
                                ),
                                label: Text(
                                  file.name,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                onDeleted: () => _removeAttachment(index),
                                deleteIconColor: Colors.red,
                                backgroundColor: Colors.white,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                  // Content field
                  Container(
                    color: Colors.white,
                    constraints: const BoxConstraints(minHeight: 300),
                    child: TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: 'Soạn nội dung email...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    bool isRequired = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                isDense: true,
                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
              keyboardType:
                  label == 'Chủ đề' ? TextInputType.text : TextInputType.phone,
              textCapitalization: TextCapitalization.none,
            ),
          ),
          if (isRequired)
            Text(
              '*',
              style: TextStyle(color: Colors.red.shade600),
            ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      case 'mp3':
      case 'wav':
        return Icons.audio_file;
      case 'zip':
      case 'rar':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }
}
