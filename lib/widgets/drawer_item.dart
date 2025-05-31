import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool highlight;
  final int? count;
  final Color? countColor;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    this.highlight = false,
    this.count,
    this.countColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? Colors.red : Colors.grey,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.red : Colors.black,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: count != null && count! > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: countColor ?? Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      selected: selected,
      selectedTileColor: highlight ? Colors.red.withOpacity(0.1) : null,
      onTap: onTap,
    );
  }
}
