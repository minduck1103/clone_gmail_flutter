import 'package:flutter/material.dart';
import 'package:gmail_app/utils/my_drawer.dart';
import '../widgets/email_list_item.dart';
import '../models/email.dart';
import 'compose_screen.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final List<Email> _emails = [
    Email(
      sender: 'Google',
      subject: 'Security alert',
      preview: 'New sign-in on Chrome on Windows',
      time: '10:45 AM',
      isRead: false,
      isStarred: true,
    ),
    Email(
      sender: 'LinkedIn',
      subject: 'New job opportunities for you',
      preview: 'Based on your profile, we found these jobs',
      time: '9:30 AM',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'Amazon',
      subject: 'Your order has shipped',
      preview: 'Your package is on the way',
      time: 'Yesterday',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'Netflix',
      subject: 'New shows added to Netflix',
      preview: 'Check out the latest shows and movies',
      time: 'Yesterday',
      isRead: false,
      isStarred: false,
    ),
    Email(
      sender: 'Twitter',
      subject: 'You have new notifications',
      preview: 'See what\'s happening on Twitter',
      time: 'May 3',
      isRead: true,
      isStarred: true,
    ),
    Email(
      sender: 'Spotify',
      subject: 'Discover Weekly: Your weekly mixtape',
      preview: 'Your weekly mixtape of fresh music',
      time: 'May 2',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'GitHub',
      subject: 'Action required: GitHub Terms of Service',
      preview: 'We\'re updating our Terms of Service',
      time: 'May 1',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'Dropbox',
      subject: 'Your storage is almost full',
      preview: 'Upgrade your plan to get more storage',
      time: 'Apr 30',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'Slack',
      subject: 'New message from Flutter Team',
      preview: 'Check out the latest updates',
      time: 'Apr 29',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'Medium',
      subject: 'Top stories for you',
      preview: 'Stories based on your reading history',
      time: 'Apr 28',
      isRead: true,
      isStarred: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int unreadEmailsCount = 2;
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
      drawer: MyDrawer(selectedTitle: 'Primary', unreadEmailsCount: unreadEmailsCount),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Inbox',
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
              'Search in emails',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  
}
