import 'package:flutter/material.dart';
import 'package:gmail_app/utils/my_drawer.dart';
import '../widgets/email_list_item.dart';
import '../models/email.dart';
import 'compose_screen.dart';


class OutboxScreen extends StatefulWidget {
  const OutboxScreen({super.key});

  @override
  State<OutboxScreen> createState() => _OutboxScreenState();
}

class _OutboxScreenState extends State<OutboxScreen> {
  final List<Email> _emails = [
    Email(
      sender: 'Me',
      subject: 'Question about invoice',
      preview: 'I had a question about the recent invoice you sent',
      time: 'Sending...',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'Me',
      subject: 'Request for information',
      preview:
          'I would like to request additional information about your services',
      time: 'Failed to send',
      isRead: true,
      isStarred: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int unreadEmailsCount = 5; 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outbox'),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade300,
            child: const Text('A', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: MyDrawer(selectedTitle: 'Outbox', unreadEmailsCount: unreadEmailsCount),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Outbox',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _emails.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return EmailListItem(email: _emails[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ComposeScreen()),
          );
        },
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Compose'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            label: 'Mail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam_outlined),
            label: 'Meet',
          ),
        ],
      ),
    );
  }

  
}
