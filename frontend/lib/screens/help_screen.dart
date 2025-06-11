import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Trung tâm trợ giúp',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm câu hỏi...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),

          // Content
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildMainContent()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Quick Actions
        _buildSectionHeader('Thao tác nhanh'),
        _buildQuickActions(),

        const SizedBox(height: 24),

        // Popular Topics
        _buildSectionHeader('Chủ đề phổ biến'),
        ..._getPopularTopics().map((topic) => _buildTopicCard(topic)),

        const SizedBox(height: 24),

        // Categories
        _buildSectionHeader('Danh mục'),
        ..._getCategories().map((category) => _buildCategoryCard(category)),

        const SizedBox(height: 24),

        // Contact Support
        _buildContactCard(),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSearchResults() {
    final results = _searchHelp();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy kết quả',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thử tìm kiếm với từ khóa khác',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return _buildSearchResultCard(result);
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            'Gửi email',
            Icons.send,
            Colors.blue,
            () => _showHelpTopic('Cách gửi email'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            'Quản lý thư',
            Icons.folder_outlined,
            Colors.green,
            () => _showHelpTopic('Quản lý thư'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            'Cài đặt',
            Icons.settings,
            Colors.orange,
            () => _showHelpTopic('Cài đặt ứng dụng'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(Map<String, dynamic> topic) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            topic['icon'] as IconData,
            color: Colors.red,
            size: 24,
          ),
        ),
        title: Text(
          topic['title'] as String,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          topic['description'] as String,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showHelpTopic(topic['title'] as String),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        leading: Icon(
          category['icon'] as IconData,
          color: Colors.grey.shade600,
        ),
        title: Text(
          category['title'] as String,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        children: (category['items'] as List<String>).map((item) {
          return ListTile(
            title: Text(item),
            trailing: const Icon(Icons.chevron_right, size: 16),
            dense: true,
            onTap: () => _showHelpTopic(item),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchResultCard(Map<String, dynamic> result) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          result['title'] as String,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          result['description'] as String,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showHelpTopic(result['title'] as String),
      ),
    );
  }

  Widget _buildContactCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.support_agent,
                  color: Colors.red,
                  size: 28,
                ),
                SizedBox(width: 12),
                Text(
                  'Cần thêm trợ giúp?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Không tìm thấy câu trả lời? Liên hệ với đội ngũ hỗ trợ của chúng tôi.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/feedback'),
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Gửi phản hồi'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showContactDialog,
                    icon: const Icon(Icons.email),
                    label: const Text('Liên hệ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpTopic(String topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      topic,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _getHelpContent(topic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getHelpContent(String topic) {
    switch (topic) {
      case 'Cách gửi email':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Để gửi email mới:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 12),
            Text('1. Nhấn vào nút "+" ở góc dưới bên phải'),
            SizedBox(height: 8),
            Text('2. Nhập địa chỉ email người nhận'),
            SizedBox(height: 8),
            Text('3. Thêm tiêu đề email'),
            SizedBox(height: 8),
            Text('4. Soạn nội dung email'),
            SizedBox(height: 8),
            Text('5. Nhấn "Gửi" để gửi email'),
          ],
        );
      case 'Quản lý thư':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quản lý email của bạn:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
                '• Gắn sao: Nhấn vào biểu tượng sao để đánh dấu email quan trọng'),
            SizedBox(height: 8),
            Text('• Xóa email: Vuốt email sang trái hoặc sử dụng menu'),
            SizedBox(height: 8),
            Text('• Tìm kiếm: Sử dụng thanh tìm kiếm ở đầu màn hình'),
            SizedBox(height: 8),
            Text('• Sắp xếp: Email được sắp xếp theo thời gian mới nhất'),
          ],
        );
      default:
        return const Text(
          'Nội dung trợ giúp cho chủ đề này đang được cập nhật. Vui lòng thử lại sau hoặc liên hệ với đội ngũ hỗ trợ.',
        );
    }
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Liên hệ hỗ trợ'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thông tin liên hệ:'),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.email, size: 16),
                SizedBox(width: 8),
                Text('support@gmail-clone.com'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 16),
                SizedBox(width: 8),
                Text('1900-xxxx'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 16),
                SizedBox(width: 8),
                Text('8:00 - 17:00 (T2-T6)'),
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

  List<Map<String, dynamic>> _getPopularTopics() {
    return [
      {
        'title': 'Cách gửi email',
        'description': 'Hướng dẫn chi tiết cách soạn và gửi email',
        'icon': Icons.send,
      },
      {
        'title': 'Quản lý thư đến',
        'description': 'Sắp xếp và tổ chức email hiệu quả',
        'icon': Icons.inbox,
      },
      {
        'title': 'Tìm kiếm email',
        'description': 'Cách tìm kiếm email nhanh chóng',
        'icon': Icons.search,
      },
      {
        'title': 'Cài đặt thông báo',
        'description': 'Tùy chỉnh thông báo email',
        'icon': Icons.notifications,
      },
    ];
  }

  List<Map<String, dynamic>> _getCategories() {
    return [
      {
        'title': 'Bắt đầu',
        'icon': Icons.play_arrow,
        'items': [
          'Tạo tài khoản mới',
          'Đăng nhập lần đầu',
          'Thiết lập ứng dụng',
          'Nhập danh bạ',
        ],
      },
      {
        'title': 'Email cơ bản',
        'icon': Icons.email,
        'items': [
          'Soạn email mới',
          'Trả lời email',
          'Chuyển tiếp email',
          'Đính kèm tệp',
        ],
      },
      {
        'title': 'Tổ chức',
        'icon': Icons.folder,
        'items': [
          'Tạo nhãn',
          'Sắp xếp email',
          'Lọc email',
          'Tìm kiếm nâng cao',
        ],
      },
      {
        'title': 'Bảo mật',
        'icon': Icons.security,
        'items': [
          'Đổi mật khẩu',
          'Xác thực hai yếu tố',
          'Quản lý phiên đăng nhập',
          'Báo cáo spam',
        ],
      },
    ];
  }

  List<Map<String, dynamic>> _searchHelp() {
    final allTopics = [
      ..._getPopularTopics(),
      ..._getCategories().expand(
          (category) => (category['items'] as List<String>).map((item) => {
                'title': item,
                'description': 'Hướng dẫn về $item',
              })),
    ];

    return allTopics
        .where((topic) =>
            topic['title']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (topic['description'] ?? '')
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }
}
