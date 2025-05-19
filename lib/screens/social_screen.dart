import 'package:flutter/material.dart';
import 'package:gmail_app/utils/my_drawer.dart';
import '../widgets/email_list_item.dart';
import '../models/email.dart';
import 'compose_screen.dart';


class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final List<Email> _emails = [
    Email(
      sender: 'Facebook',
      subject: 'John commented on your post',
      preview: 'Great work! I like what you did there...',
      time: '10:45 AM',
      isRead: false,
      isStarred: false,
    ),
    Email(
      sender: 'Twitter',
      subject: 'New followers this week',
      preview: 'You have 5 new followers this week',
      time: '9:30 AM',
      isRead: true,
      isStarred: true,
    ),
    Email(
      sender: 'LinkedIn',
      subject: 'New connection request',
      preview: 'Sarah wants to connect with you on LinkedIn',
      time: 'Yesterday',
      isRead: false,
      isStarred: false,
    ),
    Email(
      sender: 'Instagram',
      subject: 'Your post has 100+ likes',
      preview: 'Your recent post is getting a lot of attention',
      time: '2 days ago',
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
      drawer: MyDrawer(selectedTitle: 'Social', unreadEmailsCount: unreadEmailsCount),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Social',
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
              'Search in social',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
