import 'package:flutter/material.dart';

class DrawerItem {
  final IconData icon;
  final String title;
  final String route;
  final bool isDivider;
  final int count;
  final bool isSelected;

  const DrawerItem({
    this.icon = Icons.mail,
    required this.title,
    required this.route,
    this.isDivider = false,
    this.count = 0,
    this.isSelected = false,
  });
}

class DrawerItems {
  static const List<DrawerItem> items = [
    DrawerItem(icon: Icons.inbox, title: 'Primary', route: '/', count: 4),
    DrawerItem(
      icon: Icons.local_offer_outlined,
      title: 'Promotions',
      route: '/promotions',
      count: 5,
    ),
    DrawerItem(
      icon: Icons.people_outline,
      title: 'Social',
      route: '/social',
      count: 2,
    ),
    DrawerItem(
      icon: Icons.info_outline,
      title: 'Update',
      route: '/update',
      count: 2,
    ),
    DrawerItem(isDivider: true, title: '', route: ''),
    DrawerItem(
      icon: Icons.star_outline,
      title: 'Starred',
      route: '/starred',
      count: 0,
    ),
    DrawerItem(
      icon: Icons.access_time,
      title: 'Snoozed',
      route: '/snoozed',
      count: 0,
    ),
    DrawerItem(
      icon: Icons.label_important_outline,
      title: 'Important',
      route: '/important',
      isSelected: true,
    ),
    DrawerItem(icon: Icons.send, title: 'Sent', route: '/sent', count: 0),
    DrawerItem(
      icon: Icons.schedule_send_outlined,
      title: 'Scheduled',
      route: '/scheduled',
      count: 0,
    ),
    DrawerItem(icon: Icons.outbox_outlined, title: 'Outbox', route: '/outbox'),
    DrawerItem(
      icon: Icons.insert_drive_file_outlined,
      title: 'Drafts',
      route: '/drafts',
      count: 0,
    ),
    DrawerItem(
      icon: Icons.mail_outline,
      title: 'All mail',
      route: '/all-mail',
      count: 0,
    ),
    DrawerItem(
      icon: Icons.report_gmailerrorred_outlined,
      title: 'Spam',
      route: '/spam',
      count: 0,
    ),
    DrawerItem(
      icon: Icons.delete_outline,
      title: 'Trash',
      route: '/trash',
      count: 0,
    ),
    DrawerItem(isDivider: true, title: '', route: ''),
    DrawerItem(
      icon: Icons.settings_outlined,
      title: 'Settings',
      route: '/settings',
      count: 0,
    ),
    DrawerItem(
      icon: Icons.help_outline,
      title: 'Help & Feedback',
      route: '/help',
      count: 0,
    ),
  ];
}
