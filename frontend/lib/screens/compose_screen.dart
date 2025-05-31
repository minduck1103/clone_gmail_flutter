import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/email_service.dart';
import '../models/email.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({super.key});

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final _toController = TextEditingController();
  final _subjectController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _toController.dispose();
    _subjectController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _sendEmail() {
    if (_toController.text.isEmpty ||
        _subjectController.text.isEmpty ||
        _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final email = Email(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: 'Me',
      subject: _subjectController.text,
      content: _contentController.text,
      timestamp: DateTime.now(),
    );

    context.read<EmailService>().addEmail(email);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Message'),
        actions: [
          IconButton(
            icon: const Icon(Icons.attachment),
            onPressed: () {
              // TODO: Implement attachment
            },
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendEmail,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _toController,
                    decoration: const InputDecoration(
                      labelText: 'To',
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(),
                  TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: InputBorder.none,
                    ),
                  ),
                  if (_isExpanded) ...[
                    const Divider(),
                    TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Cc, Bcc',
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: 'Compose email',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                      maxLines: null,
                      expands: true,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.format_bold),
                          onPressed: () {
                            // TODO: Implement text formatting
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.format_italic),
                          onPressed: () {
                            // TODO: Implement text formatting
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.format_underlined),
                          onPressed: () {
                            // TODO: Implement text formatting
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: () {
                            // TODO: Implement attachment
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
