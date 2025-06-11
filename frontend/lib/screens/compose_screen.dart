import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../services/api_service.dart';
import '../services/email_service.dart';
import '../models/mail.dart';

class ComposeScreen extends StatefulWidget {
  final Mail? replyToEmail;
  final Mail? forwardFromEmail;
  final bool isReply;
  final bool isReplyAll;
  final bool isForward;
  final Mail? existingDraft;

  const ComposeScreen({
    super.key,
    this.replyToEmail,
    this.forwardFromEmail,
    this.isReply = false,
    this.isReplyAll = false,
    this.isForward = false,
    this.existingDraft,
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
    if (widget.existingDraft != null) {
      final draft = widget.existingDraft!;
      _toController.text = draft.recipient.join(', ');
      _subjectController.text =
          draft.title == '(Không có chủ đề)' ? '' : draft.title;
      _contentController.text = draft.content;
      if (draft.cc.isNotEmpty) {
        _ccController.text = draft.cc.join(', ');
        _showCcBcc = true;
      }
      if (draft.bcc.isNotEmpty) {
        _bccController.text = draft.bcc.join(', ');
        _showCcBcc = true;
      }
      return;
    }

    if (widget.replyToEmail != null && widget.isReply) {
      if (widget.isReplyAll) {
        List<String> allRecipients = [widget.replyToEmail!.senderPhone];
        allRecipients.addAll(widget.replyToEmail!.recipient);
        allRecipients.removeWhere((recipient) => recipient.isEmpty);
        _toController.text = allRecipients.join(', ');
      } else {
        _toController.text = widget.replyToEmail!.senderPhone;
      }
      _subjectController.text = widget.replyToEmail!.title.startsWith('Re: ')
          ? widget.replyToEmail!.title
          : 'Re: ${widget.replyToEmail!.title}';

      String replySenderDisplay =
          widget.replyToEmail!.senderName ?? widget.replyToEmail!.senderPhone;
      _contentController.text =
          '\n\n--- Tin nhắn gốc ---\nTừ: $replySenderDisplay\nChủ đề: ${widget.replyToEmail!.title}\n\n${widget.replyToEmail!.content}';
    } else if (widget.forwardFromEmail != null && widget.isForward) {
      _subjectController.text =
          widget.forwardFromEmail!.title.startsWith('Fwd: ')
              ? widget.forwardFromEmail!.title
              : 'Fwd: ${widget.forwardFromEmail!.title}';

      String senderDisplay = widget.forwardFromEmail!.senderName ??
          widget.forwardFromEmail!.senderPhone;

      // Format nội dung forward theo Gmail
      String forwardContent = '\n\n---------- Forwarded message ---------\n';
      forwardContent += 'From: $senderDisplay\n';
      forwardContent += 'Date: ${widget.forwardFromEmail!.createdAt}\n';
      forwardContent += 'Subject: ${widget.forwardFromEmail!.title}\n';
      forwardContent +=
          'To: ${widget.forwardFromEmail!.recipient.join(', ')}\n\n';
      forwardContent += widget.forwardFromEmail!.content;

      _contentController.text = forwardContent;
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

  List<String> _parsePhones(String phoneString) {
    if (phoneString.trim().isEmpty) return [];
    return phoneString
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> _sendEmail() async {
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

    setState(() {
      _isSending = true;
    });

    try {
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
      };

      final Map<String, dynamic> response;

      if (_attachments.isNotEmpty) {
        response = await ApiService.createMailWithAttachments(
          emailData,
          _attachments,
        );
      } else {
        response = await ApiService.createMail(emailData);
      }

      if (response['message'] == 'Mail created successfully') {
        if (mounted) {
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
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _saveDraft() async {
    try {
      if (widget.existingDraft != null) {
        if (_toController.text == widget.existingDraft!.recipient.join(', ') &&
            _subjectController.text == widget.existingDraft!.title &&
            _contentController.text == widget.existingDraft!.content &&
            _ccController.text == widget.existingDraft!.cc.join(', ') &&
            _bccController.text == widget.existingDraft!.bcc.join(', ')) {
          Navigator.pop(context);
          return;
        }
        final draftData = {
          'recipient': _parsePhones(_toController.text),
          'title': _subjectController.text.trim().isEmpty
              ? '(Không có chủ đề)'
              : _subjectController.text.trim(),
          'content': _contentController.text.trim(),
          'autoSave': true,
          'isRead': false,
          'isStarred': false,
          'labels': ['Thư nháp'],
          'isTrashed': false,
          'cc': _parsePhones(_ccController.text),
          'bcc': _parsePhones(_bccController.text),
          'attach': [],
        };
        await ApiService.updateMail(widget.existingDraft!.id, draftData);
      } else {
        final drafts = await ApiService.getDraftMails();
        final similarDraft = drafts.firstWhere(
          (draft) =>
            ((draft['recipient'] ?? []) as List).join(', ') == _toController.text &&
            (draft['title'] ?? '') == _subjectController.text,
          orElse: () => null,
        );
        if (similarDraft != null) {
          final draftData = {
            'recipient': _parsePhones(_toController.text),
            'title': _subjectController.text.trim().isEmpty
                ? '(Không có chủ đề)'
                : _subjectController.text.trim(),
            'content': _contentController.text.trim(),
            'autoSave': true,
            'isRead': false,
            'isStarred': false,
            'labels': ['Thư nháp'],
            'isTrashed': false,
            'cc': _parsePhones(_ccController.text),
            'bcc': _parsePhones(_bccController.text),
            'attach': [],
          };
          await ApiService.updateMail(similarDraft['_id'] ?? similarDraft['id'], draftData);
        } else {
          final draftData = {
            'recipient': _parsePhones(_toController.text),
            'title': _subjectController.text.trim().isEmpty
                ? '(Không có chủ đề)'
                : _subjectController.text.trim(),
            'content': _contentController.text.trim(),
            'autoSave': true,
            'isRead': false,
            'isStarred': false,
            'labels': ['Thư nháp'],
            'isTrashed': false,
            'cc': _parsePhones(_ccController.text),
            'bcc': _parsePhones(_bccController.text),
            'attach': [],
          };
          await ApiService.createMail(draftData);
        }
      }
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
          onPressed: () async {
            if (_toController.text.isNotEmpty ||
                _subjectController.text.isNotEmpty ||
                _contentController.text.isNotEmpty) {
              await _saveDraft();
            } else {
              Navigator.pop(context);
            }
          },
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildEmailField(
                  controller: _toController,
                  label: 'Đến',
                  hintText: 'Nhập số điện thoại người nhận',
                  isRequired: true,
                ),
                if (!_showCcBcc)
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextButton(
                      onPressed: () => setState(() => _showCcBcc = true),
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
                          Icons.insert_drive_file,
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
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Soạn nội dung email...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
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
            Text('*', style: TextStyle(color: Colors.red.shade600)),
        ],
      ),
    );
  }
}
