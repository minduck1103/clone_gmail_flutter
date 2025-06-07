import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/email_service.dart';
import 'email_detail_screen.dart';

class EmailListScreen extends StatelessWidget {
  const EmailListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmailService>(
      builder: (context, emailService, child) {
        final emails = emailService.emails;

        if (emails.isEmpty) {
          return const Center(
            child: Text('No emails to display'),
          );
        }

        return ListView.builder(
          itemCount: emails.length,
          itemBuilder: (context, index) {
            final email = emails[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(email.senderPhone[0].toUpperCase()),
              ),
              title: Text(
                email.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                email.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${email.createdAt.month}/${email.createdAt.day}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (!email.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmailDetailScreen(mail: email),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
