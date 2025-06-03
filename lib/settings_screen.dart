import 'package:flutter/material.dart';
import '../widgets/setting_tile.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cài đặt"),
        actions: [
          IconButton(
            icon: Icon(Icons.feedback),
            onPressed: () => Navigator.pushNamed(context, '/feedback'),
          ),
        ],
      ),
      body: ListView(
        children: [
          SettingTile(title: 'Tài khoản', icon: Icons.person),
          SettingTile(title: 'Thông báo', icon: Icons.notifications),
          SettingTile(title: 'Chủ đề', icon: Icons.color_lens),
          SettingTile(title: 'Bảo mật', icon: Icons.lock),
          SettingTile(
            title: 'Phản hồi',
            icon: Icons.feedback,
            onTap: () => Navigator.pushNamed(context, '/feedback'),
          ),
        ],
      ),
    );
  }
}