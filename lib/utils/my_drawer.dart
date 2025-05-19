import 'package:flutter/material.dart';
import 'navigateToScreen.dart';

class MyDrawer extends StatelessWidget {
  final String selectedTitle;
  final int unreadEmailsCount;

  const MyDrawer({
    Key? key,
    required this.selectedTitle,
    required this.unreadEmailsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      unreadEmailsCount.toString(),
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildDrawerItem(context, Icons.inbox, 'Primary', 4),// Primary
          _buildDrawerItem(context, Icons.local_offer_outlined, 'Promotions', 5),// Promotions
          _buildDrawerItem(context, Icons.people_outline, 'Social', 2),
          _buildDrawerItem(context, Icons.info_outline, 'Update', 2),
          const Divider(),
          _buildDrawerItem(context, Icons.star_outline, 'Starred', 0),
          _buildDrawerItem(context, Icons.access_time, 'Snoozed', 0),
          _buildDrawerItem(context, Icons.label_important_outline, 'Important', 0), // Important
          _buildDrawerItem(context, Icons.send, 'Sent', 0),
          _buildDrawerItem(context, Icons.schedule_send_outlined, 'Scheduled', 0),
          _buildDrawerItem(context, Icons.outbox_outlined, 'Outbox', 0), // Outbox
          _buildDrawerItem(context, Icons.insert_drive_file_outlined, 'Drafts', 0),
          _buildDrawerItem(context, Icons.mail_outline, 'All mail', 0), // All mail
          _buildDrawerItem(context, Icons.report_gmailerrorred_outlined, 'Spam', 0),
          _buildDrawerItem(context, Icons.delete_outline, 'Trash', 0),
          const Divider(),
          _buildDrawerItem(context, Icons.settings_outlined, 'Settings', 0),
          _buildDrawerItem(context, Icons.help_outline, 'Help & feedback', 0),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, int count) {
    final bool isSelected = title == selectedTitle;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.red : null),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.red : null),
      ),
      trailing: count > 0
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
        if (title != selectedTitle) {
          navigateToScreen(context, title);
        }
      },
    );
  }
}
