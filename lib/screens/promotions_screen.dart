import 'package:flutter/material.dart';
import 'package:gmail_app/utils/my_drawer.dart';
import '../widgets/email_list_item.dart';
import '../models/email.dart';
import 'compose_screen.dart';


class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key});

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  final List<Email> _emails = [
    Email(
      sender: 'Amazon',
      subject: 'Weekend Deals: 50% off!',
      preview: 'Check out these amazing deals just for you',
      time: '10:45 AM',
      isRead: false,
      isStarred: false,
    ),
    Email(
      sender: 'Spotify',
      subject: 'Get 3 months of Premium for free',
      preview: 'Exclusive offer for new subscribers',
      time: '9:30 AM',
      isRead: true,
      isStarred: false,
    ),
    Email(
      sender: 'Uber Eats',
      subject: 'Your lunch is on us',
      preview: '50% off your next order with code LUNCH50',
      time: 'Yesterday',
      isRead: true,
      isStarred: true,
    ),
    Email(
      sender: 'Booking.com',
      subject: 'Last minute deals on hotels',
      preview: 'Book now and save up to 30%',
      time: 'Yesterday',
      isRead: false,
      isStarred: false,
    ),
    Email(
      sender: 'Coursera',
      subject: 'New courses available in Flutter',
      preview: 'Start learning today with a 14-day free trial',
      time: 'May 3',
      isRead: true,
      isStarred: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int unreadEmailsCount = 5; 
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade300,
            child: const Text('A', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: MyDrawer(selectedTitle: 'Promotions', unreadEmailsCount: unreadEmailsCount),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Promotions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _emails.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return EmailListItem(email: _emails[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ComposeScreen()),
          );
        },
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Compose'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            label: 'Mail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam_outlined),
            label: 'Meet',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.menu, color: Colors.grey),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Search in promotions',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
