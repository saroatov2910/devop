// lib/widgets/bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';

class BottomNav extends StatelessWidget {
  final void Function(int) onItemTap;

  const BottomNav({super.key, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return BottomBarWithSheet(
      // The body property is passed to the BottomBarWithSheet directly
      // as part of the Scaffold, not here.
      sheetChild: Container(
        height: 200,
        color: Colors.white,
        child: const Center(child: Text("Sheet Content")),
      ),
      items: const [
        BottomBarWithSheetItem(icon: Icons.home, label: 'Home'),
        BottomBarWithSheetItem(icon: Icons.person, label: 'Profile'),
        BottomBarWithSheetItem(icon: Icons.settings, label: 'Settings'),
        // BottomBarWithSheetItem(icon: Icons.product, label: 'Product'),
        // BottomBarWithSheetItem(icon: Icons.settings, label: 'SuperMarket'),
        // BottomBarWithSheetItem(icon: Icons.Ai, label: 'Ai '),
        // BottomBarWithSheetItem(icon: Icons.settings, label: 'Settings'),
      ],
      onSelectItem: (index) {
        onItemTap(index);
      },
    );
  }
}
