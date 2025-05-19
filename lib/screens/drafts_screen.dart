import 'package:flutter/material.dart';
import 'package:gmail_app/utils/navigateToScreen.dart';
import '../widgets/email_list_item.dart';
import '../models/email.dart';
import 'compose_screen.dart';


class DraftsScreen extends StatefulWidget {
  const DraftsScreen({super.key});

  @override
  State<DraftsScreen> createState() => _DraftsScreenState();
}

class _DraftsScreenState extends State<DraftsScreen> {
  final List<Email> _emails = [
    Email(
      sender: 'Me',
      subject: 'Draft: Project proposal',
      preview: 'I am writing to propose a new project...',
      time: 'May 10',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'Me',
      subject: 'Draft: Meeting agenda',
      preview: 'Agenda for the upcoming meeting...',
      time: 'May 8',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'Me',
      subject: 'Draft: Follow-up email',
      preview: 'Following up on our discussion...',
      time: 'May 5',
      isRead: true,
      isStarred: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drafts'),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade300,
            child: const Text('A', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Drafts',
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gmail',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'All inboxes',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    const Spacer(),
                    Text(
                      '${_emails.where((e) => !e.isRead).length}',
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.inbox, 'Primary', 4),
          _buildDrawerItem(Icons.local_offer_outlined, 'Promotions', 5),
          _buildDrawerItem(Icons.people_outline, 'Social', 2),
          _buildDrawerItem(Icons.info_outline, 'Update', 2),
          const Divider(),
          _buildDrawerItem(Icons.star_outline, 'Starred', 0),
          _buildDrawerItem(Icons.access_time, 'Snoozed', 0),
          _buildDrawerItem(Icons.label_important_outline, 'Important', 0),
          _buildDrawerItem(Icons.send, 'Sent', 0),
          _buildDrawerItem(Icons.schedule_send_outlined, 'Scheduled', 0),
          _buildDrawerItem(Icons.outbox_outlined, 'Outbox', 0),
          _buildDrawerItem(
            Icons.insert_drive_file_outlined,
            'Drafts',
            0,
            isSelected: true,
          ),
          _buildDrawerItem(Icons.mail_outline, 'All mail', 0),
          _buildDrawerItem(Icons.report_gmailerrorred_outlined, 'Spam', 0),
          _buildDrawerItem(Icons.delete_outline, 'Trash', 0),
          const Divider(),
          _buildDrawerItem(Icons.settings_outlined, 'Settings', 0),
          _buildDrawerItem(Icons.help_outline, 'Help & feedback', 0),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    int count, {
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.red : null),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.red : null),
      ),
      trailing:
          count > 0
              ? Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: count > 3 ? Colors.red : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: count > 3 ? Colors.white : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              )
              : null,
      onTap: () {
        Navigator.pop(context);
        if (title != 'Drafts') {
          navigateToScreen(context, title);
        }
      },
    );
  }
}
