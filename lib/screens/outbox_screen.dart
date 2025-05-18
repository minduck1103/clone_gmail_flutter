import 'package:flutter/material.dart';
import '../widgets/email_list_item.dart';
import '../models/email.dart';
import 'compose_screen.dart';
import 'inbox_screen.dart';
import 'promotions_screen.dart';
import 'social_screen.dart';
import 'update_screen.dart';
import 'starred_screen.dart';
import 'snoozed_screen.dart';
import 'important_screen.dart';
import 'sent_screen.dart';
import 'scheduled_screen.dart';
import 'drafts_screen.dart';
import 'all_mail_screen.dart';
import 'spam_screen.dart';
import 'trash_screen.dart';

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
      drawer: _buildDrawer(context),
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
          _buildDrawerItem(
            Icons.outbox_outlined,
            'Outbox',
            0,
            isSelected: true,
          ),
          _buildDrawerItem(Icons.insert_drive_file_outlined, 'Drafts', 0),
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
        if (title != 'Outbox') {
          // Navigate to the appropriate screen based on the title
          switch (title) {
            case 'Primary':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const InboxScreen()),
              );
              break;
            case 'Promotions':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PromotionsScreen(),
                ),
              );
              break;
            case 'Social':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SocialScreen()),
              );
              break;
            case 'Update':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const UpdateScreen()),
              );
              break;
            case 'Starred':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const StarredScreen()),
              );
              break;
            case 'Snoozed':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SnoozedScreen()),
              );
              break;
            case 'Important':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ImportantScreen(),
                ),
              );
              break;
            case 'Sent':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SentScreen()),
              );
              break;
            case 'Scheduled':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScheduledScreen(),
                ),
              );
              break;
            case 'Drafts':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DraftsScreen()),
              );
              break;
            case 'All mail':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AllMailScreen()),
              );
              break;
            case 'Spam':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SpamScreen()),
              );
              break;
            case 'Trash':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TrashScreen()),
              );
              break;
            default:
              // For other options like Settings and Help & feedback, we'll implement later
              break;
          }
        }
      },
    );
  }
}
