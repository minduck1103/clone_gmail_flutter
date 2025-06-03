import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gửi phản hồi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Chúng tôi luôn sẵn sàng lắng nghe bạn!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Nhập phản hồi tại đây...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã gửi phản hồi. Cảm ơn bạn!')),
                  );
                  _controller.clear();
                }
              },
              icon: Icon(Icons.send),
              label: Text('Gửi'),
            ),
          ],
        ),
      ),
    );
  }
}