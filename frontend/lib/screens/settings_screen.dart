import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _darkMode = false;
  bool _autoSync = true;
  bool _autoAnswer = false;
  String _autoAnswerMessage =
      'Thank you for your message. I will get back to you soon.';
  String _selectedLanguage = 'Tiếng Việt';
  String _syncFrequency = '15 phút';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader('Tài khoản'),
          _buildAccountCard(),

          const SizedBox(height: 16),

          // General Settings
          _buildSectionHeader('Chung'),
          _buildSettingsCard([
            _buildSwitchTile(
              'Thông báo',
              'Nhận thông báo từ ứng dụng',
              Icons.notifications_outlined,
              _notificationsEnabled,
              (value) => setState(() => _notificationsEnabled = value),
            ),
            _buildDivider(),
            _buildNavigationTile(
              'Ngôn ngữ',
              _selectedLanguage,
              Icons.language,
              () => _showLanguageDialog(),
            ),
            _buildDivider(),
            _buildSwitchTile(
              'Chế độ tối',
              'Sử dụng giao diện tối',
              Icons.dark_mode_outlined,
              _darkMode,
              (value) => setState(() => _darkMode = value),
            ),
          ]),

          const SizedBox(height: 16),

          // Email Settings
          _buildSectionHeader('Email'),
          _buildSettingsCard([
            _buildSwitchTile(
              'Đồng bộ tự động',
              'Tự động kiểm tra email mới',
              Icons.sync,
              _autoSync,
              (value) => setState(() => _autoSync = value),
            ),
            _buildDivider(),
            _buildNavigationTile(
              'Tần suất đồng bộ',
              _syncFrequency,
              Icons.schedule,
              () => _showSyncFrequencyDialog(),
            ),
            _buildDivider(),
            _buildSwitchTile(
              'Thông báo email',
              'Nhận thông báo khi có email mới',
              Icons.email_outlined,
              _emailNotifications,
              (value) => setState(() => _emailNotifications = value),
            ),
            _buildDivider(),
            _buildSwitchTile(
              'Thông báo đẩy',
              'Hiển thị thông báo trên màn hình',
              Icons.push_pin_outlined,
              _pushNotifications,
              (value) => setState(() => _pushNotifications = value),
            ),
            _buildDivider(),
            _buildSwitchTile(
              'Trả lời tự động',
              'Tự động trả lời email khi không có mặt',
              Icons.auto_awesome,
              _autoAnswer,
              (value) => setState(() => _autoAnswer = value),
            ),
            if (_autoAnswer) ...[
              _buildDivider(),
              _buildNavigationTile(
                'Tin nhắn trả lời tự động',
                _autoAnswerMessage.length > 50
                    ? '${_autoAnswerMessage.substring(0, 50)}...'
                    : _autoAnswerMessage,
                Icons.message_outlined,
                () => _showAutoAnswerMessageDialog(),
              ),
            ],
          ]),

          const SizedBox(height: 16),

          // Security Settings
          _buildSectionHeader('Bảo mật'),
          _buildSettingsCard([
            _buildNavigationTile(
              'Đổi mật khẩu',
              'Cập nhật mật khẩu của bạn',
              Icons.lock_outline,
              () => Navigator.pushNamed(context, '/change-password'),
            ),
            _buildDivider(),
            _buildNavigationTile(
              'Xác thực hai yếu tố',
              'Tăng cường bảo mật tài khoản',
              Icons.security,
              () => _showTwoFactorDialog(),
            ),
            _buildDivider(),
            _buildNavigationTile(
              'Phiên đăng nhập',
              'Quản lý các thiết bị đã đăng nhập',
              Icons.devices_outlined,
              () => _showSessionsDialog(),
            ),
          ]),

          const SizedBox(height: 16),

          // Storage Settings
          _buildSectionHeader('Lưu trữ'),
          _buildSettingsCard([
            _buildNavigationTile(
              'Quản lý dung lượng',
              'Xem và quản lý dung lượng lưu trữ',
              Icons.storage,
              () => _showStorageDialog(),
            ),
            _buildDivider(),
            _buildNavigationTile(
              'Xóa dữ liệu cache',
              'Giải phóng bộ nhớ tạm',
              Icons.cleaning_services_outlined,
              () => _showClearCacheDialog(),
            ),
          ]),

          const SizedBox(height: 16),

          // Help & Support
          _buildSectionHeader('Trợ giúp & Hỗ trợ'),
          _buildSettingsCard([
            _buildNavigationTile(
              'Trung tâm trợ giúp',
              'Tìm câu trả lời cho câu hỏi của bạn',
              Icons.help_outline,
              () => Navigator.pushNamed(context, '/help'),
            ),
            _buildDivider(),
            _buildNavigationTile(
              'Liên hệ hỗ trợ',
              'Gửi phản hồi hoặc báo cáo sự cố',
              Icons.support_agent,
              () => Navigator.pushNamed(context, '/feedback'),
            ),
            _buildDivider(),
            _buildNavigationTile(
              'Điều khoản dịch vụ',
              'Đọc điều khoản sử dụng',
              Icons.description_outlined,
              () => _showTermsDialog(),
            ),
            _buildDivider(),
            _buildNavigationTile(
              'Chính sách bảo mật',
              'Tìm hiểu cách chúng tôi bảo vệ dữ liệu',
              Icons.privacy_tip_outlined,
              () => _showPrivacyDialog(),
            ),
          ]),

          const SizedBox(height: 16),

          // About
          _buildSectionHeader('Về ứng dụng'),
          _buildSettingsCard([
            _buildNavigationTile(
              'Phiên bản',
              '1.0.0',
              Icons.info_outline,
              () => _showAboutDialog(),
            ),
          ]),

          const SizedBox(height: 32),

          // Logout Button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: _showLogoutDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Đăng xuất',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAccountCard() {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.user;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.red.shade100,
                backgroundImage:
                    user?.avatar != null ? NetworkImage(user!.avatar!) : null,
                child: user?.avatar == null
                    ? Icon(
                        Icons.person,
                        color: Colors.red,
                        size: 24,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.fullname ?? 'Người dùng',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.phone ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/account'),
                icon: const Icon(Icons.edit_outlined),
                color: Colors.grey.shade600,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.red,
      ),
    );
  }

  Widget _buildNavigationTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade200,
      indent: 56,
    );
  }

  void _showLanguageDialog() {
    final languages = ['Tiếng Việt', 'English', '中文', '日本語'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn ngôn ngữ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) {
            return RadioListTile<String>(
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
              title: Text(language),
              activeColor: Colors.red,
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSyncFrequencyDialog() {
    final frequencies = ['5 phút', '15 phút', '30 phút', '1 giờ', 'Thủ công'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tần suất đồng bộ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: frequencies.map((frequency) {
            return RadioListTile<String>(
              value: frequency,
              groupValue: _syncFrequency,
              onChanged: (value) {
                setState(() {
                  _syncFrequency = value!;
                });
                Navigator.pop(context);
              },
              title: Text(frequency),
              activeColor: Colors.red,
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showTwoFactorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác thực hai yếu tố'),
        content: const Text(
          'Tính năng xác thực hai yếu tố giúp bảo vệ tài khoản của bạn bằng cách yêu cầu mã xác minh từ điện thoại.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tính năng sẽ được cập nhật'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                const Text('Kích hoạt', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSessionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Phiên đăng nhập'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thiết bị hiện tại:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.phone_android, color: Colors.green.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Điện thoại Android',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Đang hoạt động',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showStorageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quản lý dung lượng'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Email:'),
                const Text('1.2 GB'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tệp đính kèm:'),
                const Text('0.5 GB'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Cache:'),
                const Text('0.1 GB'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tổng cộng:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('1.8 GB',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa dữ liệu cache'),
        content: const Text(
          'Việc xóa cache sẽ giải phóng bộ nhớ nhưng có thể làm chậm ứng dụng trong lần mở đầu tiên.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã xóa cache thành công'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Điều khoản dịch vụ'),
        content: const SingleChildScrollView(
          child: Text(
            'Đây là nội dung điều khoản dịch vụ. Trong ứng dụng thực tế, đây sẽ là văn bản pháp lý chi tiết về các quyền và nghĩa vụ của người dùng.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chính sách bảo mật'),
        content: const SingleChildScrollView(
          child: Text(
            'Đây là nội dung chính sách bảo mật. Trong ứng dụng thực tế, đây sẽ là văn bản chi tiết về cách thu thập, sử dụng và bảo vệ dữ liệu người dùng.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Gmail Clone',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.email,
          color: Colors.white,
          size: 32,
        ),
      ),
      children: [
        const Text('Ứng dụng email đơn giản và dễ sử dụng.'),
        const SizedBox(height: 16),
        const Text('Được phát triển bằng Flutter.'),
      ],
    );
  }

  void _showAutoAnswerMessageDialog() {
    final controller = TextEditingController(text: _autoAnswerMessage);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tin nhắn trả lời tự động'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nhập tin nhắn sẽ được gửi tự động khi có email mới:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập tin nhắn trả lời tự động...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _autoAnswerMessage = controller.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã cập nhật tin nhắn trả lời tự động'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất khỏi tài khoản?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AuthService>().logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
