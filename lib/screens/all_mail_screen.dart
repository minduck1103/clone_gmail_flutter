import 'package:flutter/material.dart';
import '../utils/my_drawer.dart';
import '../widgets/email_list_item.dart';
import '../models/email.dart';
import 'compose_screen.dart';


class AllMailScreen extends StatefulWidget {
  const AllMailScreen({super.key});

  @override
  State<AllMailScreen> createState() => _AllMailScreenState();
}

class _AllMailScreenState extends State<AllMailScreen> {
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
      sender: 'Me',
      subject: 'Meeting Schedule',
      preview: 'Let\'s schedule a meeting for tomorrow at 10 AM',
      time: 'May 5',
      isRead: true,
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Mail'),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade300,
            child: const Text('A', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: MyDrawer(selectedTitle: 'All mail', unreadEmailsCount: 7),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Text(
              'All Mail',
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
