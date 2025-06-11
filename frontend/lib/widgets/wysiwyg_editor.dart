import 'package:flutter/material.dart';

class WysiwygEditor extends StatefulWidget {
  final String? initialValue;
  final Function(String) onChanged;
  final double height;

  const WysiwygEditor({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.height = 300,
  });

  @override
  State<WysiwygEditor> createState() => _WysiwygEditorState();
}

class _WysiwygEditorState extends State<WysiwygEditor> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String _htmlContent = '';

  // Formatting states
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Convert HTML to plain text for initial display
    String initialText = widget.initialValue ?? '';
    if (initialText.isNotEmpty) {
      _controller.text = _htmlToPlainText(initialText);
      _htmlContent = initialText;
    }

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _htmlToPlainText(String html) {
    return html
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
  }

  String _plainTextToHtml(String text) {
    if (text.isEmpty) return '';

    String html = text;

    // Convert line breaks to <br/> tags
    html = html.replaceAll('\n', '<br/>');

    // Wrap in paragraph if not empty
    if (html.isNotEmpty) {
      html = '<p>$html</p>';
    }

    return html;
  }

  void _onTextChanged() {
    _htmlContent = _plainTextToHtml(_controller.text);
    widget.onChanged(_htmlContent);
  }

  void _applyFormatting(String tag) {
    final selection = _controller.selection;
    final text = _controller.text;

    if (selection.isValid && selection.start != selection.end) {
      // User has selected text
      final selectedText = text.substring(selection.start, selection.end);
      String formattedText = '';

      switch (tag) {
        case 'bold':
          formattedText = '<strong>$selectedText</strong>';
          break;
        case 'italic':
          formattedText = '<em>$selectedText</em>';
          break;
        case 'underline':
          formattedText = '<u>$selectedText</u>';
          break;
      }

      // Replace selected text with formatted version
      final newText =
          text.replaceRange(selection.start, selection.end, selectedText);
      _controller.text = newText;

      // Update HTML content with formatting
      _htmlContent = _htmlContent.replaceAll(selectedText, formattedText);
      widget.onChanged(_htmlContent);

      // Restore cursor position
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: selection.start + selectedText.length),
      );
    }
  }

  void _toggleBold() {
    setState(() {
      _isBold = !_isBold;
    });
    if (_controller.selection.isValid &&
        _controller.selection.start != _controller.selection.end) {
      _applyFormatting('bold');
    }
  }

  void _toggleItalic() {
    setState(() {
      _isItalic = !_isItalic;
    });
    if (_controller.selection.isValid &&
        _controller.selection.start != _controller.selection.end) {
      _applyFormatting('italic');
    }
  }

  void _toggleUnderline() {
    setState(() {
      _isUnderline = !_isUnderline;
    });
    if (_controller.selection.isValid &&
        _controller.selection.start != _controller.selection.end) {
      _applyFormatting('underline');
    }
  }

  void _insertList(bool isOrdered) {
    final text = _controller.text;
    final lines = text.split('\n');

    String listHtml = '';
    if (isOrdered) {
      listHtml = '<ol>';
      for (String line in lines) {
        if (line.trim().isNotEmpty) {
          listHtml += '<li>${line.trim()}</li>';
        }
      }
      listHtml += '</ol>';
    } else {
      listHtml = '<ul>';
      for (String line in lines) {
        if (line.trim().isNotEmpty) {
          listHtml += '<li>${line.trim()}</li>';
        }
      }
      listHtml += '</ul>';
    }

    _htmlContent = listHtml;
    widget.onChanged(_htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Bold
                  IconButton(
                    icon: Icon(
                      Icons.format_bold,
                      color: _isBold ? Colors.blue : Colors.grey.shade600,
                    ),
                    onPressed: _toggleBold,
                    tooltip: 'Đậm (Ctrl+B)',
                  ),
                  // Italic
                  IconButton(
                    icon: Icon(
                      Icons.format_italic,
                      color: _isItalic ? Colors.blue : Colors.grey.shade600,
                    ),
                    onPressed: _toggleItalic,
                    tooltip: 'Nghiêng (Ctrl+I)',
                  ),
                  // Underline
                  IconButton(
                    icon: Icon(
                      Icons.format_underlined,
                      color: _isUnderline ? Colors.blue : Colors.grey.shade600,
                    ),
                    onPressed: _toggleUnderline,
                    tooltip: 'Gạch chân (Ctrl+U)',
                  ),
                  const VerticalDivider(),
                  // Bullet List
                  IconButton(
                    icon: Icon(
                      Icons.format_list_bulleted,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () => _insertList(false),
                    tooltip: 'Danh sách',
                  ),
                  // Numbered List
                  IconButton(
                    icon: Icon(
                      Icons.format_list_numbered,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () => _insertList(true),
                    tooltip: 'Danh sách số',
                  ),
                  const Spacer(),
                  // Format indicator
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.text_format,
                          size: 16,
                          color: Colors.blue.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Rich Text',
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Text Editor
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  hintText: 'Nhập nội dung email với rich text formatting...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                  decoration: _isUnderline
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),
          ),
          // Status bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Ký tự: ${_controller.text.length}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                if (_isBold || _isItalic || _isUnderline) ...[
                  Text(
                    'Định dạng: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (_isBold)
                    Text(
                      'B ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  if (_isItalic)
                    Text(
                      'I ',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  if (_isUnderline)
                    Text(
                      'U',
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        color: Colors.blue.shade600,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Public methods
  String getContent() {
    return _htmlContent;
  }

  void setContent(String content) {
    _htmlContent = content;
    _controller.text = _htmlToPlainText(content);
  }

  String getPlainText() {
    return _controller.text;
  }
}
