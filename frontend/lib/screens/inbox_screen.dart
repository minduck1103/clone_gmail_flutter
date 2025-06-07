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
        return 'Hoãn lại';
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
    Future.microtask(() => context.read<EmailService>().fetchInboxMails());
  }

  void _selectPage(GmailPage page) {
    setState(() {
      _currentPage = page;
    });

    final emailService = context.read<EmailService>();

    switch (page) {
      case GmailPage.primary:
        emailService.fetchInboxMails(); // Trang chính hiển thị tất cả thư đến
        break;
      case GmailPage.promotions:
        emailService.fetchInboxMails(); // Placeholder
        break;
      case GmailPage.social:
        emailService.fetchInboxMails(); // Placeholder
        break;
      case GmailPage.updates:
        emailService.fetchInboxMails(); // Placeholder
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
        emailService.fetchInboxMails(); // Placeholder
        break;
      case GmailPage.snoozed:
        emailService.fetchInboxMails(); // Placeholder
        break;
      case GmailPage.scheduled:
        emailService.fetchInboxMails(); // Placeholder
        break;
      case GmailPage.outbox:
        emailService.fetchInboxMails(); // Placeholder
        break;
      case GmailPage.allMail:
        emailService.fetchAllMails();
        break;
      case GmailPage.spam:
        emailService.fetchInboxMails(); // Placeholder
        break;
      default:
        emailService.fetchInboxMails();
        break;
    }

    Navigator.pop(context);
  }

  void _handleEmailTap(Mail email) {
    Navigator.pushNamed(
      context,
      '/email',
      arguments: email,
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
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tính năng cài đặt sẽ được cập nhật'),
          ),
        );
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
          onEmailTap: _handleEmailTap,
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

  @override
  void dispose() {
    _searchController.dispose();
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
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm trong thư',
                          border: InputBorder.none,
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      _searchQuery = '';
                                      _searchController.clear();
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
                  Consumer<AuthService>(
                    builder: (context, authService, child) {
                      final user = authService.user;
                      return PopupMenuButton<String>(
                        onSelected: _handleAvatarMenuSelection,
                        offset: const Offset(0, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.red.shade50,
                          backgroundImage: user?.avatar != null
                              ? NetworkImage(user!.avatar!)
                              : null,
                          child: user?.avatar == null
                              ? Icon(
                                  Icons.person,
                                  color: Colors.red.shade300,
                                  size: 20,
                                )
                              : null,
                        ),
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'account_info',
                            enabled: false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.fullname ?? 'Người dùng',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.phone ?? '',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<String>(
                            value: 'account',
                            child: Row(
                              children: const [
                                Icon(Icons.person, color: Colors.grey),
                                SizedBox(width: 12),
                                Text('Tài khoản cá nhân'),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'settings',
                            child: Row(
                              children: const [
                                Icon(Icons.settings, color: Colors.grey),
                                SizedBox(width: 12),
                                Text('Cài đặt'),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<String>(
                            value: 'logout',
                            child: Row(
                              children: const [
                                Icon(Icons.logout, color: Colors.red),
                                SizedBox(width: 12),
                                Text(
                                  'Đăng xuất',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFEAF3FB),
        child: ListView(
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
              onTap: () => _selectPage(GmailPage.primary),
            ),
            DrawerItem(
              icon: Icons.local_offer,
              label: 'Quảng cáo',
              selected: _currentPage == GmailPage.promotions,
              onTap: () => _selectPage(GmailPage.promotions),
            ),
            DrawerItem(
              icon: Icons.people,
              label: 'Mạng xã hội',
              selected: _currentPage == GmailPage.social,
              onTap: () => _selectPage(GmailPage.social),
            ),
            DrawerItem(
              icon: Icons.info,
              label: 'Cập nhật',
              selected: _currentPage == GmailPage.updates,
              onTap: () => _selectPage(GmailPage.updates),
            ),

            // 2. Tất cả nhãn
            const DrawerSectionHeader(title: 'Tất cả nhãn'),
            DrawerItem(
              icon: Icons.star,
              label: 'Có gắn dấu sao',
              selected: _currentPage == GmailPage.starred,
              onTap: () => _selectPage(GmailPage.starred),
            ),
            DrawerItem(
              icon: Icons.snooze,
              label: 'Đã tạm ẩn',
              selected: _currentPage == GmailPage.snoozed,
              onTap: () => _selectPage(GmailPage.snoozed),
            ),
            DrawerItem(
              icon: Icons.label_important,
              label: 'Quan trọng',
              selected: _currentPage == GmailPage.important,
              onTap: () => _selectPage(GmailPage.important),
            ),
            DrawerItem(
              icon: Icons.send,
              label: 'Đã gửi',
              selected: _currentPage == GmailPage.sent,
              onTap: () => _selectPage(GmailPage.sent),
            ),
            DrawerItem(
              icon: Icons.schedule,
              label: 'Đã lên lịch',
              selected: _currentPage == GmailPage.scheduled,
              onTap: () => _selectPage(GmailPage.scheduled),
            ),
            DrawerItem(
              icon: Icons.outbox,
              label: 'Hộp thư đi',
              selected: _currentPage == GmailPage.outbox,
              onTap: () => _selectPage(GmailPage.outbox),
            ),
            DrawerItem(
              icon: Icons.drafts,
              label: 'Thư nháp',
              selected: _currentPage == GmailPage.drafts,
              onTap: () => _selectPage(GmailPage.drafts),
            ),
            DrawerItem(
              icon: Icons.all_inbox,
              label: 'Tất cả thư',
              selected: _currentPage == GmailPage.allMail,
              onTap: () => _selectPage(GmailPage.allMail),
            ),
            DrawerItem(
              icon: Icons.report,
              label: 'Thư rác',
              selected: _currentPage == GmailPage.spam,
              onTap: () => _selectPage(GmailPage.spam),
            ),
            DrawerItem(
              icon: Icons.delete,
              label: 'Thùng rác',
              selected: _currentPage == GmailPage.trash,
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
        ),
      ),
      body: Column(
        children: [
          // Page Title Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Text(
              _getPageTitle(_currentPage),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // Page Content
          Expanded(
            child: Consumer<EmailService>(
              builder: (context, emailService, child) {
                if (emailService.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (emailService.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Đã xảy ra lỗi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          emailService.error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return _buildPageContent();
              },
            ),
          ),
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
