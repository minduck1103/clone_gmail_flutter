import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mail.dart';
import '../services/email_service.dart';

class LabelManagementDialog extends StatefulWidget {
  final Mail email;

  const LabelManagementDialog({
    super.key,
    required this.email,
  });

  @override
  State<LabelManagementDialog> createState() => _LabelManagementDialogState();
}

class _LabelManagementDialogState extends State<LabelManagementDialog> {
  final TextEditingController _newLabelController = TextEditingController();
  Set<String> selectedLabels = {};
  List<String> availableLabels = [
    'Có gắn dấu sao',
    'Đã tạm ẩn',
    'Quan trọng',
    'Đã gửi',
    'Đã lên lịch',
    'Hộp thư đi',
    'Thư nháp',
    'Thùng rác',
    'Spam',
    'Tất cả thư',
  ];

  @override
  void initState() {
    super.initState();
    selectedLabels = Set<String>.from(widget.email.labels ?? []);
  }

  @override
  void dispose() {
    _newLabelController.dispose();
    super.dispose();
  }

  void _addNewLabel() {
    final newLabel = _newLabelController.text.trim();
    if (newLabel.isNotEmpty && !availableLabels.contains(newLabel)) {
      setState(() {
        availableLabels.add(newLabel);
        selectedLabels.add(newLabel);
      });
      _newLabelController.clear();
    }
  }

  void _saveLabels() {
    final emailService = context.read<EmailService>();
    emailService.updateLabels(widget.email.id, selectedLabels.toList());

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã cập nhật nhãn email'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _getLabelIcon(String label) {
    IconData iconData;
    switch (label) {
      case 'Có gắn dấu sao':
        iconData = Icons.star;
        break;
      case 'Đã tạm ẩn':
        iconData = Icons.snooze;
        break;
      case 'Quan trọng':
        iconData = Icons.label_important;
        break;
      case 'Đã gửi':
        iconData = Icons.send;
        break;
      case 'Đã lên lịch':
        iconData = Icons.schedule_send;
        break;
      case 'Hộp thư đi':
        iconData = Icons.outbox;
        break;
      case 'Thư nháp':
        iconData = Icons.drafts;
        break;
      case 'Thùng rác':
        iconData = Icons.delete;
        break;
      case 'Spam':
        iconData = Icons.report;
        break;
      case 'Tất cả thư':
        iconData = Icons.mail;
        break;
      default:
        iconData = Icons.label;
    }

    return Icon(
      iconData,
      size: 16,
      color: _getLabelColor(label),
    );
  }

  Color _getLabelColor(String label) {
    switch (label) {
      case 'Có gắn dấu sao':
        return Colors.orange;
      case 'Đã tạm ẩn':
        return Colors.purple;
      case 'Quan trọng':
        return Colors.red;
      case 'Đã gửi':
        return Colors.blue;
      case 'Đã lên lịch':
        return Colors.green;
      case 'Hộp thư đi':
        return Colors.teal;
      case 'Thư nháp':
        return Colors.grey;
      case 'Thùng rác':
        return Colors.red.shade800;
      case 'Spam':
        return Colors.deepOrange;
      case 'Tất cả thư':
        return Colors.indigo;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quản lý nhãn'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.email.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Từ: ${widget.email.senderName ?? widget.email.senderPhone}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newLabelController,
                    decoration: const InputDecoration(
                      hintText: 'Thêm nhãn mới...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _addNewLabel(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addNewLabel,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Chọn nhãn:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableLabels.map((label) {
                    final isSelected = selectedLabels.contains(label);
                    return FilterChip(
                      avatar: _getLabelIcon(label),
                      label: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedLabels.add(label);
                          } else {
                            selectedLabels.remove(label);
                          }
                        });
                      },
                      selectedColor: _getLabelColor(label).withOpacity(0.2),
                      checkmarkColor: _getLabelColor(label),
                      backgroundColor: Colors.grey.shade100,
                      side: BorderSide(
                        color: isSelected
                            ? _getLabelColor(label)
                            : Colors.grey.shade300,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _saveLabels,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
 