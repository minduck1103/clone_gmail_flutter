import 'package:flutter/material.dart';
import 'package:gmail_app/utils/my_drawer.dart';
import '../widgets/email_list_item.dart';
import '../models/email.dart';
import 'compose_screen.dart';


class ScheduledScreen extends StatefulWidget {
  const ScheduledScreen({super.key});

  @override
  State<ScheduledScreen> createState() => _ScheduledScreenState();
}

class _ScheduledScreenState extends State<ScheduledScreen> {
  final List<Email> _emails = [
    Email(
      sender: 'Me',
      subject: 'Weekly Team Meeting',
      preview: 'Agenda for the weekly team meeting',
      time: 'Tomorrow, 9:00 AM',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'Me',
      subject: 'Project Status Update',
      preview: 'Here is the latest update on our project',
      time: 'Friday, 8:00 AM',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'Me',
      subject: 'Happy Birthday!',
      preview: 'Happy birthday to you! Hope you have a great day!',
      time: 'May 15, 9:00 AM',
      isRead: true,
      isStarred: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int unreadEmailsCount = 5;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled'),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade300,
            child: const Text('A', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: MyDrawer(selectedTitle: 'Scheduled', unreadEmailsCount: unreadEmailsCount),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Scheduled',
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
