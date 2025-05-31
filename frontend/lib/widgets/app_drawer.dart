import 'package:flutter/material.dart';
import '../models/drawer_item.dart';
import 'drawer_list_item.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gmail',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ...DrawerItems.items.map((item) => DrawerListItem(
                item: item,
                onTap: () {
                  Navigator.pushNamed(context, item.route);
                },
              )),
        ],
      ),
    );
  }
} 