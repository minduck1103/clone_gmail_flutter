import 'package:flutter/material.dart';
import 'package:gmail_app/utils/my_drawer.dart';
import '../widgets/email_list_item.dart';
import '../models/email.dart';
import 'compose_screen.dart';


class SpamScreen extends StatefulWidget {
  const SpamScreen({super.key});

  @override
  State<SpamScreen> createState() => _SpamScreenState();
}

class _SpamScreenState extends State<SpamScreen> {
  final List<Email> _emails = [
    Email(
      sender: 'Unknown',
      subject: 'You won a prize!',
      preview: 'Congratulations! You have been selected as a winner',
      time: '10:45 AM',
      isRead: false,
      isStarred: false,
    ),
    Email(
      sender: 'Marketing Team',
      subject: 'Last chance to claim your offer',
      preview: 'Don\'t miss out on this exclusive deal',
      time: 'Yesterday',
      isRead: false,
      isStarred: false,
    ),
    Email(
      sender: 'Service',
      subject: 'Verify your account',
      preview: 'Please click the link to verify your account',
      time: 'May 5',
      isRead: true,
      isStarred: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int unreadEmailsCount = 5; // Example unread emails count
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spam'),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade300,
            child: const Text('A', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: MyDrawer(selectedTitle: 'Spam', unreadEmailsCount: unreadEmailsCount),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Spam',
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
