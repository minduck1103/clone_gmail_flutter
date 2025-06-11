import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/email_service.dart';
import '../services/auth_service.dart';
import '../models/mail.dart';
import '../widgets/drawer_item.dart';
import '../widgets/drawer_section_header.dart';
import '../widgets/email_item.dart';
import 'gmail_pages/primary_page.dart';
import 'gmail_pages/promotions_page.dart';
import 'gmail_pages/social_page.dart';
import 'gmail_pages/updates_page.dart';
import 'gmail_pages/starred_page.dart';
import 'gmail_pages/sent_page.dart';
import 'gmail_pages/drafts_page.dart';
import 'gmail_pages/trash_page.dart';
import 'gmail_pages/important_page.dart';
import 'gmail_pages/snoozed_page.dart';
import 'gmail_pages/scheduled_page.dart';
import 'gmail_pages/outbox_page.dart';
import 'gmail_pages/all_mail_page.dart';
import 'gmail_pages/spam_page.dart';
import 'compose_screen.dart';
import 'email_list_screen.dart';
import '../widgets/email_action_bottom_sheet.dart';
import '../widgets/image_viewer.dart';

// Các loại trang chính
enum GmailPage {
  primary,
  promotions,
  social,
  updates,
  starred,
  snoozed,
  important,
  sent,
  scheduled,
  outbox,
  drafts,
  allMail,
  spam,
  trash,
  calendar,
  contacts,
  settings,
  help,
}

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  GmailPage _currentPage = GmailPage.primary;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Advanced search variables
  bool _showAdvancedSearch = false;
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  String? _selectedLabel;
  String? _selectedTimeFilter;

  final List<String> _timeFilters = [
    'Mọi lúc',
    'Hơn 1 tuần trước',
    'Hơn 1 tháng trước',
    'Hơn 1 năm trước',
  ];

  String _getPageTitle(GmailPage page) {
    switch (page) {
      case GmailPage.primary:
        return 'Chính';
      case GmailPage.promotions:
        return 'Quảng cáo';
      case GmailPage.social:
        return 'Mạng xã hội';
      case GmailPage.updates:
        return 'Cập nhật';
      case GmailPage.starred:
        return 'Đã gắn sao';
      case GmailPage.sent:
        return 'Đã gửi';
      case GmailPage.drafts:
        return 'Nháp';
      case GmailPage.trash:
        return 'Thùng rác';
      case GmailPage.important:
        return 'Quan trọng';
      case GmailPage.snoozed:
        return 'Đã tạm ẩn';
      case GmailPage.scheduled:
        return 'Đã lên lịch';
      case GmailPage.outbox:
        return 'Hộp thư đi';
      case GmailPage.allMail:
        return 'Tất cả thư';
      case GmailPage.spam:
        return 'Spam';
      default:
        return 'Gmail';
    }
  }

  @override
  void initState() {
    super.initState();
    // Gọi API lấy dữ liệu khi màn hình được tải
    Future.microtask(() {
      final emailService = context.read<EmailService>();
      emailService.fetchInboxMails(); // Trang chính chỉ hiển thị thư đến
      emailService.fetchAllMailCounts();
    });
  }

  void _selectPage(GmailPage page) {
    setState(() {
      _currentPage = page;
    });

    final emailService = context.read<EmailService>();

    switch (page) {
      case GmailPage.primary:
        emailService.fetchInboxMails(); // Trang chính chỉ hiển thị thư đến
        break;
      case GmailPage.promotions:
        // Mặc định trống
        emailService.clearEmails();
        break;
      case GmailPage.social:
        // Mặc định trống
        emailService.clearEmails();
        break;
      case GmailPage.updates:
        // Mặc định trống
        emailService.clearEmails();
        break;
      case GmailPage.starred:
        emailService.fetchStarredMails();
        break;
      case GmailPage.sent:
        emailService.fetchSentMails();
        break;
      case GmailPage.drafts:
        emailService.fetchDraftMails();
        break;
      case GmailPage.trash:
        emailService.fetchTrashedMails();
        break;
      case GmailPage.important:
        // Chỉ hiển thị mail có label "Quan trọng"
        emailService.fetchMailsByLabel("Quan trọng");
        break;
      case GmailPage.snoozed:
        // Chỉ hiển thị mail có label "Đã tạm ẩn"
        emailService.fetchMailsByLabel("Đã tạm ẩn");
        break;
      case GmailPage.scheduled:
        // Chỉ hiển thị mail có label "Đã lên lịch"
        emailService.fetchMailsByLabel("Đã lên lịch");
        break;
      case GmailPage.outbox:
        // Chỉ hiển thị mail có label "Hộp thư đi"
        emailService.fetchMailsByLabel("Hộp thư đi");
        break;
      case GmailPage.allMail:
        emailService.fetchAllMails();
        break;
      case GmailPage.spam:
        // Chỉ hiển thị mail có label "Spam"
        emailService.fetchMailsByLabel("Spam");
        break;
      default:
        emailService.fetchInboxMails();
        break;
    }

    // Refresh all counts after page change
    emailService.fetchAllMailCounts();

    Navigator.pop(context);
  }

  void _handleEmailTap(Mail email) {
    Navigator.pushNamed(
      context,
      '/email',
      arguments: email,
    );
  }

  void _handleDraftTap(Mail email) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComposeScreen(
          existingDraft: email,
        ),
      ),
    );
  }

  void _handleStarEmail(Mail email) {
    final emailService = context.read<EmailService>();
    emailService.toggleStarred(email.id);
  }

  void _handleAvatarMenuSelection(String value) async {
    switch (value) {
      case 'account':
        Navigator.pushNamed(context, '/account');
        break;
      case 'logout':
        _showLogoutDialog();
        break;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content:
              const Text('Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    final authService = context.read<AuthService>();
    await authService.logout();

    // Navigate to login screen and clear all previous routes
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  List<Mail> _convertMailsToEmails(List<dynamic> mails) {
    if (mails is List<Mail>) {
      return mails;
    }
    return mails.map((mail) {
      if (mail is Map<String, dynamic>) {
        return Mail.fromJson(mail);
      } else if (mail is Mail) {
        return mail;
      }
      throw Exception('Invalid mail data format');
    }).toList();
  }

  Widget _buildPageContent() {
    final emailService = Provider.of<EmailService>(context);
    final emails = _convertMailsToEmails(emailService.emails);
    final error = emailService.error;
    final filteredEmails = _searchQuery.isEmpty
        ? emails
        : emails
            .where((e) =>
                e.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                e.senderPhone
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                e.content.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    switch (_currentPage) {
      case GmailPage.primary:
        return PrimaryPage(
          emails: filteredEmails,
          onEmailTap: _handleEmailTap,
          onStarEmail: _handleStarEmail,
          error: error,
        );
      case GmailPage.promotions:
        return PromotionsPage(
          emails: filteredEmails,
          onEmailTap: _handleEmailTap,
          onStarEmail: _handleStarEmail,
        );
      case GmailPage.social:
        return SocialPage(
          emails: filteredEmails,
          onEmailTap: _handleEmailTap,
          onStarEmail: _handleStarEmail,
        );
      case GmailPage.updates:
        return UpdatesPage(
          emails: filteredEmails,
          onEmailTap: _handleEmailTap,
          onStarEmail: _handleStarEmail,
        );
      case GmailPage.starred:
        return StarredPage(
          emails: filteredEmails,
          onEmailTap: _handleEmailTap,
          onStarEmail: _handleStarEmail,
        );
      case GmailPage.sent:
        return SentPage(
          emails: filteredEmails,
          onEmailTap: _handleEmailTap,
          onStarEmail: _handleStarEmail,
        );
      case GmailPage.drafts:
        return DraftsPage(
          emails: filteredEmails,
          onEmailTap: _handleDraftTap,
          onStarEmail: _handleStarEmail,
        );
      case GmailPage.trash:
        return TrashPage(
          emails: filteredEmails,
          onEmailTap: _handleEmailTap,
          onStarEmail: _handleStarEmail,
        );
      case GmailPage.important:
        return ImportantPage(
          emails: filteredEmails,
          onEmailTap: _handleEmailTap,
          onStarEmail: _handleStarEmail,
        );
      case GmailPage.snoozed:
        return SnoozedPage(
          emails: filteredEmails,
          onEmailTap: _handleEmailTap,
          onStarEmail: _handleStarEmail,
        );
      case GmailPage.scheduled:
        return ScheduledPage(
          emails: filteredEmails,
          onEmailTap: _handleEmailTap,
          onStarEmail: _handleStarEmail,
        );
      case GmailPage.outbox:
        return OutboxPage(
          emails: filteredEmails,
          onEmailTap: _handleEmailTap,
          onStarEmail: _handleStarEmail,
        );
      case GmailPage.allMail:
        return AllMailPage(
          emails: filteredEmails,
          onEmailTap: _handleEmailTap,
          onStarEmail: _handleStarEmail,
        );
      case GmailPage.spam:
        return SpamPage(
          emails: filteredEmails,
          onEmailTap: _handleEmailTap,
          onStarEmail: _handleStarEmail,
        );
      default:
        return ListView.builder(
          itemCount: filteredEmails.length,
          itemBuilder: (context, index) {
            final email = filteredEmails[index];
            return EmailItem(
              email: email,
              onTap: () => _handleEmailTap(email),
              onStar: () => _handleStarEmail(email),
              onLongPress: () => EmailActionBottomSheet.show(context, email),
            );
          },
        );
    }
  }

  Future<void> _performAdvancedSearch() async {
    try {
      final emailService = context.read<EmailService>();
      await emailService.fetchAllMails();
      final allMails = emailService.emails;

      // Áp dụng basic search
      var filteredMails = _searchQuery.isEmpty
          ? allMails
          : allMails
              .where((e) =>
                  e.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  e.senderPhone
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()) ||
                  e.content.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

      // Lọc theo người gửi
      if (_fromController.text.isNotEmpty) {
        filteredMails = filteredMails.where((mail) {
          return mail.senderPhone
                  .toLowerCase()
                  .contains(_fromController.text.toLowerCase()) ||
              (mail.senderName
                      ?.toLowerCase()
                      .contains(_fromController.text.toLowerCase()) ??
                  false);
        }).toList();
      }

      // Lọc theo người nhận
      if (_toController.text.isNotEmpty) {
        filteredMails = filteredMails.where((mail) {
          return mail.recipient.any((recipient) => recipient
              .toLowerCase()
              .contains(_toController.text.toLowerCase()));
        }).toList();
      }

      // Lọc theo nhãn
      if (_selectedLabel != null) {
        filteredMails = filteredMails
            .where((mail) => mail.labels.contains(_selectedLabel))
            .toList();
      }

      // Lọc theo thời gian
      if (_selectedTimeFilter != null && _selectedTimeFilter != 'Mọi lúc') {
        final now = DateTime.now();
        filteredMails = filteredMails.where((mail) {
          switch (_selectedTimeFilter) {
            case 'Hơn 1 tuần trước':
              return now.difference(mail.createdAt).inDays > 7;
            case 'Hơn 1 tháng trước':
              return now.difference(mail.createdAt).inDays > 30;
            case 'Hơn 1 năm trước':
              return now.difference(mail.createdAt).inDays > 365;
            default:
              return true;
          }
        }).toList();
      }

      // Update search query để trigger re-render với filtered emails
      setState(() {
        // Đặt searchQuery để system biết đang trong chế độ search
        if (_fromController.text.isNotEmpty ||
            _toController.text.isNotEmpty ||
            _selectedLabel != null ||
            (_selectedTimeFilter != null && _selectedTimeFilter != 'Mọi lúc')) {
          _searchQuery = _searchQuery.isEmpty ? ' ' : _searchQuery;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tìm kiếm: $e')),
      );
    }
  }

  void _clearAdvancedSearch() {
    setState(() {
      _fromController.clear();
      _toController.clear();
      _selectedLabel = null;
      _selectedTimeFilter = null;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  Widget _buildTabChip(String title, GmailPage page) {
    final isSelected = _currentPage == page;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(title),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _currentPage = page;
          });
          _loadPageData(page);
        },
        selectedColor: Colors.blue.shade100,
        checkmarkColor: Colors.blue.shade700,
        labelStyle: TextStyle(
          color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  void _loadPageData(GmailPage page) {
    final emailService = context.read<EmailService>();

    switch (page) {
      case GmailPage.primary:
        emailService.fetchInboxMails();
        break;
      case GmailPage.promotions:
      case GmailPage.social:
      case GmailPage.updates:
        // Có thể implement logic riêng cho từng tab
        emailService.fetchInboxMails();
        break;
      default:
        emailService.fetchInboxMails();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Builder(
            builder: (context) => Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        onTap: () {
                          setState(() {
                            _showAdvancedSearch = true;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm trong thư',
                          border: InputBorder.none,
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.search, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _showAdvancedSearch = !_showAdvancedSearch;
                              });
                            },
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      _searchQuery = '';
                                      _searchController.clear();
                                      _showAdvancedSearch = false;
                                    });
                                  },
                                )
                              : null,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey.shade300,
                    child: IconButton(
                      icon: const Icon(Icons.account_circle, size: 20),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pushNamed(context, '/account');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFEAF3FB),
        child: Consumer<EmailService>(
          builder: (context, emailService, child) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text('Gmail',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                ),
                const Divider(),

                // 1. Tất cả hộp thư đến
                const DrawerSectionHeader(title: 'Tất cả hộp thư đến'),
                DrawerItem(
                  icon: Icons.inbox,
                  label: 'Chính',
                  selected: _currentPage == GmailPage.primary,
                  highlight: _currentPage == GmailPage.primary,
                  count: emailService.inboxCount,
                  onTap: () => _selectPage(GmailPage.primary),
                ),
                DrawerItem(
                  icon: Icons.local_offer,
                  label: 'Quảng cáo',
                  selected: _currentPage == GmailPage.promotions,
                  count: emailService.promotionsCount,
                  onTap: () => _selectPage(GmailPage.promotions),
                ),
                DrawerItem(
                  icon: Icons.people,
                  label: 'Mạng xã hội',
                  selected: _currentPage == GmailPage.social,
                  count: emailService.socialCount,
                  onTap: () => _selectPage(GmailPage.social),
                ),
                DrawerItem(
                  icon: Icons.info,
                  label: 'Cập nhật',
                  selected: _currentPage == GmailPage.updates,
                  count: emailService.updatesCount,
                  onTap: () => _selectPage(GmailPage.updates),
                ),

                // 2. Tất cả nhãn
                const DrawerSectionHeader(title: 'Tất cả nhãn'),
                DrawerItem(
                  icon: Icons.star,
                  label: 'Có gắn dấu sao',
                  selected: _currentPage == GmailPage.starred,
                  count: emailService.starredCount,
                  onTap: () => _selectPage(GmailPage.starred),
                ),
                DrawerItem(
                  icon: Icons.snooze,
                  label: 'Đã tạm ẩn',
                  selected: _currentPage == GmailPage.snoozed,
                  count: emailService.snoozedCount,
                  onTap: () => _selectPage(GmailPage.snoozed),
                ),
                DrawerItem(
                  icon: Icons.label_important,
                  label: 'Quan trọng',
                  selected: _currentPage == GmailPage.important,
                  count: emailService.importantCount,
                  onTap: () => _selectPage(GmailPage.important),
                ),
                DrawerItem(
                  icon: Icons.send,
                  label: 'Đã gửi',
                  selected: _currentPage == GmailPage.sent,
                  count: emailService.sentCount,
                  onTap: () => _selectPage(GmailPage.sent),
                ),
                DrawerItem(
                  icon: Icons.schedule,
                  label: 'Đã lên lịch',
                  selected: _currentPage == GmailPage.scheduled,
                  count: emailService.scheduledCount,
                  onTap: () => _selectPage(GmailPage.scheduled),
                ),
                DrawerItem(
                  icon: Icons.outbox,
                  label: 'Hộp thư đi',
                  selected: _currentPage == GmailPage.outbox,
                  count: emailService.outboxCount,
                  onTap: () => _selectPage(GmailPage.outbox),
                ),
                DrawerItem(
                  icon: Icons.drafts,
                  label: 'Thư nháp',
                  selected: _currentPage == GmailPage.drafts,
                  count: emailService.draftCount,
                  onTap: () => _selectPage(GmailPage.drafts),
                ),
                DrawerItem(
                  icon: Icons.all_inbox,
                  label: 'Tất cả thư',
                  selected: _currentPage == GmailPage.allMail,
                  count: emailService.allMailCount,
                  onTap: () => _selectPage(GmailPage.allMail),
                ),
                DrawerItem(
                  icon: Icons.report,
                  label: 'Thư rác',
                  selected: _currentPage == GmailPage.spam,
                  count: emailService.spamCount,
                  onTap: () => _selectPage(GmailPage.spam),
                ),
                DrawerItem(
                  icon: Icons.delete,
                  label: 'Thùng rác',
                  selected: _currentPage == GmailPage.trash,
                  count: emailService.trashCount,
                  onTap: () => _selectPage(GmailPage.trash),
                ),

                // 3. Các ứng dụng của Google
                const DrawerSectionHeader(title: 'Các ứng dụng của Google'),
                DrawerItem(
                  icon: Icons.calendar_today,
                  label: 'Lịch',
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/calendar');
                  },
                ),
                DrawerItem(
                  icon: Icons.contacts,
                  label: 'Danh bạ',
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/contacts');
                  },
                ),

                // 4. Khác
                const DrawerSectionHeader(title: 'Khác'),
                DrawerItem(
                  icon: Icons.settings,
                  label: 'Cài đặt',
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                DrawerItem(
                  icon: Icons.help_outline,
                  label: 'Trợ giúp và phản hồi',
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/help');
                  },
                ),

                const SizedBox(height: 20), // Khoảng trống cuối
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Advanced Search Panel
          if (_showAdvancedSearch)
            Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // From field
                    SizedBox(
                      width: 85,
                      height: 45,
                      child: TextField(
                        controller: _fromController,
                        decoration: InputDecoration(
                          labelText: 'Từ',
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          labelStyle: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                        style: const TextStyle(fontSize: 13),
                        onChanged: (value) => _performAdvancedSearch(),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // To field
                    SizedBox(
                      width: 85,
                      height: 45,
                      child: TextField(
                        controller: _toController,
                        decoration: InputDecoration(
                          labelText: 'Đến',
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          labelStyle: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                        style: const TextStyle(fontSize: 13),
                        onChanged: (value) => _performAdvancedSearch(),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Label dropdown
                    SizedBox(
                      width: 90,
                      height: 55,
                      child: DropdownButtonFormField<String>(
                        value: _selectedLabel,
                        decoration: InputDecoration(
                          labelText: 'Nhãn',
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          labelStyle: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(
                              value: null,
                              child: Text('Tất cả',
                                  style: TextStyle(fontSize: 13))),
                          const DropdownMenuItem(
                              value: 'Công việc',
                              child: Text('Công việc',
                                  style: TextStyle(fontSize: 13))),
                          const DropdownMenuItem(
                              value: 'Cá nhân',
                              child: Text('Cá nhân',
                                  style: TextStyle(fontSize: 13))),
                          const DropdownMenuItem(
                              value: 'Quan trọng',
                              child: Text('Quan trọng',
                                  style: TextStyle(fontSize: 13))),
                          const DropdownMenuItem(
                              value: 'Thư nháp',
                              child: Text('Thư nháp',
                                  style: TextStyle(fontSize: 13))),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedLabel = value;
                          });
                          _performAdvancedSearch();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Time filter dropdown
                    SizedBox(
                      width: 85,
                      height: 55,
                      child: DropdownButtonFormField<String>(
                        value: _selectedTimeFilter,
                        decoration: InputDecoration(
                          labelText: 'Thời gian',
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          labelStyle: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(
                              value: 'Mọi lúc',
                              child: Text('Mọi lúc',
                                  style: TextStyle(fontSize: 13))),
                          const DropdownMenuItem(
                              value: 'Hơn 1 tuần trước',
                              child: Text('Hơn 1 tuần',
                                  style: TextStyle(fontSize: 13))),
                          const DropdownMenuItem(
                              value: 'Hơn 1 tháng trước',
                              child: Text('Hơn 1 tháng',
                                  style: TextStyle(fontSize: 13))),
                          const DropdownMenuItem(
                              value: 'Hơn 1 năm trước',
                              child: Text('Hơn 1 năm',
                                  style: TextStyle(fontSize: 13))),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedTimeFilter = value;
                          });
                          _performAdvancedSearch();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Action buttons
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: _clearAdvancedSearch,
                            tooltip: 'Xóa bộ lọc',
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.keyboard_arrow_up, size: 18),
                            onPressed: () {
                              setState(() {
                                _showAdvancedSearch = false;
                              });
                            },
                            tooltip: 'Ẩn',
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Email content
          Expanded(child: _buildPageContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ComposeScreen()),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
