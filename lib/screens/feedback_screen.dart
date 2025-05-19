import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gửi phản hồi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Chúng tôi luôn sẵn sàng lắng nghe bạn!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              maxLines: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập phản hồi của bạn tại đây...',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Cảm ơn bạn đã gửi phản hồi!"),
                ));
                _feedbackController.clear();
              },
              child: Text('Gửi'),
            )
          ],
        ),
      ),
    );
  }
}