import 'package:flutter/material.dart';
import '../models/drawer_item.dart';

class DrawerListItem extends StatelessWidget {
  final DrawerItem item;
  final VoidCallback? onTap;

  const DrawerListItem({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (item.isDivider) {
      return const Divider();
    }

    return ListTile(
      leading: Icon(
        item.icon,
        color: item.isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[700],
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: item.isSelected ? Theme.of(context).colorScheme.primary : Colors.black87,
          fontWeight: item.isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: item.count > 0
          ? Text(
              item.count.toString(),
              style: TextStyle(
                color: item.isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[700],
              ),
            )
          : null,
      selected: item.isSelected,
      selectedTileColor: Colors.red[50],
      onTap: onTap,
    );
  }
} 