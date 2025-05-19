import 'package:flutter/material.dart';
import 'package:gmail_app/utils/my_drawer.dart';
import '../widgets/email_list_item.dart';
import '../models/email.dart';
import 'compose_screen.dart';


class SnoozedScreen extends StatefulWidget {
  const SnoozedScreen({super.key});

  @override
  State<SnoozedScreen> createState() => _SnoozedScreenState();
}

class _SnoozedScreenState extends State<SnoozedScreen> {
  final List<Email> _emails = [
    Email(
      sender: 'Coursera',
      subject: 'Complete your course "Flutter Development"',
      preview: 'You\'re 70% through this course. Keep going!',
      time: 'Tomorrow, 9:00 AM',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'Amazon',
      subject: 'Your order #123456 has shipped',
      preview: 'Track your package',
      time: 'Saturday, 8:00 AM',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'Netflix',
      subject: 'New recommendation based on your watching',
      preview: 'Check out these shows we think you\'ll love',
      time: 'Monday, 7:00 AM',
      isRead: true,
      isStarred: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int unreadEmailsCount = 5; // Example unread emails count

    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade300,
            child: const Text('A', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: MyDrawer(selectedTitle: 'Snoozed', unreadEmailsCount: unreadEmailsCount),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Snoozed',
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

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.menu, color: Colors.grey),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Search in snoozed',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
