import 'package:flutter/material.dart';

void navigateToScreen(BuildContext context, String title) {
  final routeMap = {
    'Primary': '/inbox',
    'Promotions': '/promotions',
    'Social': '/social',
    'Update': '/update',
    'Starred': '/starred',
    'Snoozed': '/snoozed',
    'Important': '/important',
    'Sent': '/sent',
    'Scheduled': '/scheduled',
    'Outbox': '/outbox',
    'Drafts': '/drafts',
    'All mail': '/allmail',
    'Spam': '/spam',
    'Trash': '/trash',
    'Settings': '/settings', 
    'Help & feedback': '/feedback', 
  };

  final routeName = routeMap[title];
  if (routeName != null) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}