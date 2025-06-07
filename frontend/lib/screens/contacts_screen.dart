import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          'Danh bạ',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: _toggleSearch,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onSelected: (value) {
              _handleMenuAction(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'import',
                child: Text('Nhập danh bạ'),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Text('Xuất danh bạ'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Cài đặt'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.red,
          tabs: const [
            Tab(text: 'Liên hệ'),
            Tab(text: 'Thường xuyên'),
            Tab(text: 'Nhóm'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          if (_searchQuery.isNotEmpty || _searchController.text.isNotEmpty)
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
                  hintText: 'Tìm kiếm liên hệ...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
            ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContactsList(),
                _buildFrequentContacts(),
                _buildGroups(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        backgroundColor: Colors.red,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  Widget _buildContactsList() {
    final contacts = _getContacts();
    final filteredContacts = _searchQuery.isEmpty
        ? contacts
        : contacts.where((contact) =>
            contact['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            contact['phone'].contains(_searchQuery)).toList();

    if (filteredContacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contacts_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? 'Chưa có liên hệ nào' : 'Không tìm thấy liên hệ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_searchQuery.isEmpty)
              const SizedBox(height: 8),
            if (_searchQuery.isEmpty)
              Text(
                'Thêm liên hệ mới bằng cách nhấn nút +',
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
      itemCount: filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = filteredContacts[index];
        return _buildContactItem(contact);
      },
    );
  }

  Widget _buildContactItem(Map<String, dynamic> contact) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getAvatarColor(contact['name']),
        child: Text(
          contact['name'][0].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        contact['name'],
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contact['phone']),
          if (contact['email'] != null && contact['email'].isNotEmpty)
            Text(
              contact['email'],
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) => _handleContactAction(value, contact),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'call',
            child: Text('Gọi điện'),
          ),
          const PopupMenuItem(
            value: 'message',
            child: Text('Nhắn tin'),
          ),
          const PopupMenuItem(
            value: 'email',
            child: Text('Gửi email'),
          ),
          const PopupMenuItem(
            value: 'edit',
            child: Text('Chỉnh sửa'),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Text('Xóa'),
          ),
        ],
      ),
      onTap: () => _showContactDetails(contact),
    );
  }

  Widget _buildFrequentContacts() {
    final frequentContacts = _getFrequentContacts();

    if (frequentContacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có liên hệ thường xuyên',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Những người bạn liên lạc thường xuyên sẽ xuất hiện ở đây',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: frequentContacts.length,
      itemBuilder: (context, index) {
        final contact = frequentContacts[index];
        return _buildContactItem(contact);
      },
    );
  }

  Widget _buildGroups() {
    final groups = _getGroups();

    if (groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có nhóm liên hệ nào',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tạo nhóm để quản lý liên hệ dễ dàng hơn',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red.shade100,
            child: Icon(
              Icons.group,
              color: Colors.red,
            ),
          ),
          title: Text(
            group['name'],
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          subtitle: Text('${group['count']} thành viên'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showGroupDetails(group),
        );
      },
    );
  }

  void _toggleSearch() {
    setState(() {
      if (_searchController.text.isNotEmpty) {
        _searchController.clear();
        _searchQuery = '';
      } else {
        _searchQuery = ' '; // Trigger search bar display
      }
    });
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'import':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tính năng nhập danh bạ sẽ được cập nhật')),
        );
        break;
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tính năng xuất danh bạ sẽ được cập nhật')),
        );
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tính năng cài đặt sẽ được cập nhật')),
        );
        break;
    }
  }

  void _handleContactAction(String action, Map<String, dynamic> contact) {
    switch (action) {
      case 'call':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gọi ${contact['name']}')),
        );
        break;
      case 'message':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nhắn tin cho ${contact['name']}')),
        );
        break;
      case 'email':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gửi email cho ${contact['name']}')),
        );
        break;
      case 'edit':
        _showAddContactDialog(contact: contact);
        break;
      case 'delete':
        _showDeleteContactDialog(contact);
        break;
    }
  }

  void _showContactDetails(Map<String, dynamic> contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: _getAvatarColor(contact['name']),
              child: Text(
                contact['name'][0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              contact['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              contact['phone'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            if (contact['email'] != null && contact['email'].isNotEmpty)
              Text(
                contact['email'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.call, 'Gọi', () {
                  Navigator.pop(context);
                  _handleContactAction('call', contact);
                }),
                _buildActionButton(Icons.message, 'Tin nhắn', () {
                  Navigator.pop(context);
                  _handleContactAction('message', contact);
                }),
                _buildActionButton(Icons.email, 'Email', () {
                  Navigator.pop(context);
                  _handleContactAction('email', contact);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.red,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showAddContactDialog({Map<String, dynamic>? contact}) {
    final nameController = TextEditingController(text: contact?['name'] ?? '');
    final phoneController = TextEditingController(text: contact?['phone'] ?? '');
    final emailController = TextEditingController(text: contact?['email'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(contact != null ? 'Chỉnh sửa liên hệ' : 'Thêm liên hệ mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tên',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email (không bắt buộc)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
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
              if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      contact != null ? 'Đã cập nhật liên hệ' : 'Đã thêm liên hệ mới'
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              contact != null ? 'Cập nhật' : 'Thêm',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteContactDialog(Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa liên hệ "${contact['name']}"?'),
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
                  content: Text('Đã xóa liên hệ'),
                  backgroundColor: Colors.green,
                ),
              );
              setState(() {});
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showGroupDetails(Map<String, dynamic> group) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Xem chi tiết nhóm ${group['name']}')),
    );
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[name.hashCode % colors.length];
  }

  List<Map<String, dynamic>> _getContacts() {
    return [
      {'name': 'Nguyễn Văn A', 'phone': '0912345678', 'email': 'a@example.com'},
      {'name': 'Trần Thị B', 'phone': '0987654321', 'email': 'b@example.com'},
      {'name': 'Lê Văn C', 'phone': '0123456789', 'email': ''},
      {'name': 'Phạm Thị D', 'phone': '0998877665', 'email': 'd@example.com'},
      {'name': 'Hoàng Văn E', 'phone': '0111222333', 'email': ''},
    ];
  }

  List<Map<String, dynamic>> _getFrequentContacts() {
    return [
      {'name': 'Nguyễn Văn A', 'phone': '0912345678', 'email': 'a@example.com'},
      {'name': 'Trần Thị B', 'phone': '0987654321', 'email': 'b@example.com'},
    ];
  }

  List<Map<String, dynamic>> _getGroups() {
    return [
      {'name': 'Gia đình', 'count': 5},
      {'name': 'Bạn bè', 'count': 12},
      {'name': 'Công việc', 'count': 8},
    ];
  }
} 