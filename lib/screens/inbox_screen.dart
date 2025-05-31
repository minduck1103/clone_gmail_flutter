import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/email_service.dart';
import '../models/email.dart';
import '../widgets/drawer_item.dart';
import '../widgets/email_item.dart';
import 'gmail_pages/primary_page.dart';
import 'gmail_pages/promotions_page.dart';
import 'gmail_pages/social_page.dart';
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

// Các loại trang chính
enum GmailPage {
  primary,
  promotions,
  social,
  updates,
  starred,
  sent,
  drafts,
  trash,
  important,
  snoozed,
  scheduled,
  outbox,
  allMail,
  spam,
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

  // Mock data cho số lượng thư mới
  final Map<GmailPage, int> mockCounts = {
    GmailPage.primary: 0,
    GmailPage.promotions: 17,
    GmailPage.social: 11,
    GmailPage.updates: 71,
    GmailPage.important: 5,
    GmailPage.allMail: 525,
    GmailPage.spam: 18,
  };

  // Mock data cho từng loại email
  final Map<GmailPage, List<Email>> mockEmails = {
    GmailPage.primary: [
      Email(
          id: '1',
          sender: 'Nguyễn Văn A',
          subject: 'Chào bạn',
          content: 'Đây là email chính.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10))),
      Email(
          id: '2',
          sender: 'Công ty ABC',
          subject: 'Thông báo',
          content: 'Bạn có thông báo mới.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1))),
    ],
    GmailPage.promotions: [
      Email(
          id: '3',
          sender: 'Shopee',
          subject: 'Khuyến mãi 50%',
          content: 'Mua sắm thả ga!',
          timestamp: DateTime.now().subtract(const Duration(hours: 2))),
    ],
    GmailPage.social: [
      Email(
          id: '4',
          sender: 'Facebook',
          subject: 'Bạn có thông báo mới',
          content: 'Ai đó đã thích bài viết của bạn.',
          timestamp: DateTime.now().subtract(const Duration(hours: 3))),
    ],
    GmailPage.updates: [
      Email(
          id: '5',
          sender: 'Google',
          subject: 'Cập nhật bảo mật',
          content: 'Tài khoản của bạn đã được cập nhật.',
          timestamp: DateTime.now().subtract(const Duration(days: 1))),
    ],
    GmailPage.starred: [
      Email(
          id: '6',
          sender: 'Sếp',
          subject: 'Quan trọng',
          content: 'Nhớ hoàn thành công việc.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          isStarred: true),
    ],
    GmailPage.sent: [
      Email(
          id: '7',
          sender: 'Me',
          subject: 'Báo cáo',
          content: 'Đây là báo cáo.',
          timestamp: DateTime.now().subtract(const Duration(days: 2))),
    ],
    GmailPage.drafts: [
      Email(
          id: '8',
          sender: 'Me',
          subject: 'Nháp',
          content: 'Soạn nháp...',
          timestamp: DateTime.now().subtract(const Duration(days: 3))),
    ],
    GmailPage.trash: [
      Email(
          id: '9',
          sender: 'Spam',
          subject: 'Xóa',
          content: 'Đã xóa.',
          timestamp: DateTime.now().subtract(const Duration(days: 4))),
    ],
    GmailPage.important: [
      Email(
          id: '10',
          sender: 'HR',
          subject: 'Phỏng vấn',
          content: 'Lịch phỏng vấn.',
          timestamp: DateTime.now().subtract(const Duration(hours: 5))),
    ],
    GmailPage.snoozed: [],
    GmailPage.scheduled: [],
    GmailPage.outbox: [],
    GmailPage.allMail: [],
    GmailPage.spam: [],
  };

  void _selectPage(GmailPage page) {
    setState(() {
      _currentPage = page;
    });
    Navigator.pop(context);
  }

  void _handleEmailTap(Email email) {
    Navigator.pushNamed(
      context,
      '/email',
      arguments: email,
    );
  }

  void _handleStarEmail(Email email) {
    setState(() {
      final updatedEmail = email.copyWith(isStarred: !email.isStarred);
      final index = mockEmails[_currentPage]!.indexOf(email);
      mockEmails[_currentPage]![index] = updatedEmail;
    });
  }

  Widget _buildPageContent() {
    final emails = mockEmails[_currentPage] ?? [];
    final filteredEmails = _searchQuery.isEmpty
        ? emails
        : emails
            .where((e) =>
                e.subject.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                e.sender.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                e.content.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    switch (_currentPage) {
      case GmailPage.primary:
        return PrimaryPage(
          emails: filteredEmails,
          onEmailTap: _handleEmailTap,
          onStarEmail: _handleStarEmail,
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
                  GestureDetector(
                    onTap: () {},
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                          'https://randomuser.me/api/portraits/men/32.jpg'),
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text('Gmail',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            DrawerItem(
              icon: Icons.inbox,
              label: 'Chính',
              selected: _currentPage == GmailPage.primary,
              highlight: _currentPage == GmailPage.primary,
              count: mockCounts[GmailPage.primary],
              onTap: () => _selectPage(GmailPage.primary),
            ),
            DrawerItem(
              icon: Icons.local_offer,
              label: 'Quảng cáo',
              count: mockCounts[GmailPage.promotions],
              countColor: Colors.green,
              selected: _currentPage == GmailPage.promotions,
              onTap: () => _selectPage(GmailPage.promotions),
            ),
            DrawerItem(
              icon: Icons.people,
              label: 'Mạng xã hội',
              count: mockCounts[GmailPage.social],
              countColor: Colors.blue,
              selected: _currentPage == GmailPage.social,
              onTap: () => _selectPage(GmailPage.social),
            ),
            DrawerItem(
              icon: Icons.info,
              label: 'Cập nhật',
              count: mockCounts[GmailPage.updates],
              countColor: Colors.orange,
              selected: _currentPage == GmailPage.updates,
              onTap: () => _selectPage(GmailPage.updates),
            ),
            const Divider(),
            DrawerItem(
              icon: Icons.star,
              label: 'Đã gắn sao',
              selected: _currentPage == GmailPage.starred,
              onTap: () => _selectPage(GmailPage.starred),
            ),
            DrawerItem(
              icon: Icons.send,
              label: 'Đã gửi',
              selected: _currentPage == GmailPage.sent,
              onTap: () => _selectPage(GmailPage.sent),
            ),
            DrawerItem(
              icon: Icons.drafts,
              label: 'Nháp',
              selected: _currentPage == GmailPage.drafts,
              onTap: () => _selectPage(GmailPage.drafts),
            ),
            DrawerItem(
              icon: Icons.delete,
              label: 'Thùng rác',
              selected: _currentPage == GmailPage.trash,
              onTap: () => _selectPage(GmailPage.trash),
            ),
            const Divider(),
            DrawerItem(
              icon: Icons.label_important,
              label: 'Quan trọng',
              selected: _currentPage == GmailPage.important,
              onTap: () => _selectPage(GmailPage.important),
            ),
            DrawerItem(
              icon: Icons.snooze,
              label: 'Hoãn lại',
              selected: _currentPage == GmailPage.snoozed,
              onTap: () => _selectPage(GmailPage.snoozed),
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
              icon: Icons.all_inbox,
              label: 'Tất cả thư',
              count: mockCounts[GmailPage.allMail],
              selected: _currentPage == GmailPage.allMail,
              onTap: () => _selectPage(GmailPage.allMail),
            ),
            DrawerItem(
              icon: Icons.report,
              label: 'Spam',
              count: mockCounts[GmailPage.spam],
              selected: _currentPage == GmailPage.spam,
              onTap: () => _selectPage(GmailPage.spam),
            ),
          ],
        ),
      ),
      body: _buildPageContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/compose');
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
