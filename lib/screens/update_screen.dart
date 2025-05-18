import 'package:flutter/material.dart';
import '../widgets/email_list_item.dart';
import '../models/email.dart';
import 'compose_screen.dart';
import 'inbox_screen.dart';
import 'promotions_screen.dart';
import 'social_screen.dart';
import 'starred_screen.dart';
import 'snoozed_screen.dart';
import 'important_screen.dart';
import 'sent_screen.dart';
import 'scheduled_screen.dart';
import 'outbox_screen.dart';
import 'drafts_screen.dart';
import 'all_mail_screen.dart';
import 'spam_screen.dart';
import 'trash_screen.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final List<Email> _emails = [
    Email(
      sender: 'Google Play',
      subject: 'Your apps have been updated',
      preview: '5 apps were updated automatically',
      time: '10:45 AM',
      isRead: false,
      isStarred: false,
    ),
    Email(
      sender: 'YouTube',
      subject: 'Terms of Service update',
      preview: 'We\'re updating our Terms of Service',
      time: '9:30 AM',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'Microsoft',
      subject: 'Your subscription was renewed',
      preview: 'Your Microsoft 365 subscription has been renewed',
      time: 'Yesterday',
      isRead: false,
      isStarred: false,
    ),
    Email(
      sender: 'Apple',
      subject: 'Receipt for your App Store purchase',
      preview: 'Thank you for your purchase',
      time: '2 days ago',
      isRead: true,
      isStarred: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Updates',
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
              'Search in updates',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
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
          _buildDrawerItem(context, Icons.inbox, 'Primary', 4),
          _buildDrawerItem(
            context,
            Icons.local_offer_outlined,
            'Promotions',
            5,
          ),
          _buildDrawerItem(context, Icons.people_outline, 'Social', 2),
          _buildDrawerItem(
            context,
            Icons.info_outline,
            'Update',
            2,
            isSelected: true,
          ),
          const Divider(),
          _buildDrawerItem(context, Icons.star_outline, 'Starred', 0),
          _buildDrawerItem(context, Icons.access_time, 'Snoozed', 0),
          _buildDrawerItem(
            context,
            Icons.label_important_outline,
            'Important',
            0,
          ),
          _buildDrawerItem(context, Icons.send, 'Sent', 0),
          _buildDrawerItem(
            context,
            Icons.schedule_send_outlined,
            'Scheduled',
            0,
          ),
          _buildDrawerItem(context, Icons.outbox_outlined, 'Outbox', 0),
          _buildDrawerItem(
            context,
            Icons.insert_drive_file_outlined,
            'Drafts',
            0,
          ),
          _buildDrawerItem(context, Icons.mail_outline, 'All mail', 0),
          _buildDrawerItem(
            context,
            Icons.report_gmailerrorred_outlined,
            'Spam',
            0,
          ),
          _buildDrawerItem(context, Icons.delete_outline, 'Trash', 0),
          const Divider(),
          _buildDrawerItem(context, Icons.settings_outlined, 'Settings', 0),
          _buildDrawerItem(context, Icons.help_outline, 'Help & feedback', 0),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
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
        if (title != 'Update') {
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
            case 'Outbox':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const OutboxScreen()),
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
