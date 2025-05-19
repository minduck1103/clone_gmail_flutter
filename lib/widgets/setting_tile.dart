import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const SettingTile({
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}