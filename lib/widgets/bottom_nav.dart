import 'package:flutter/material.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';

/// Bottom navigation bar widget with a dynamic scan button.
/// The first tab changes icon and label based on [isScanning] state.
/// [onItemTap] is called when a navigation item is selected.
class BottomNav extends StatelessWidget {
  final void Function(int) onItemTap; // Callback for item selection
  final bool isScanning; // Indicates if scanning is active

  const BottomNav({
    super.key,
    required this.onItemTap,
    required this.isScanning,
  });

  @override
  Widget build(BuildContext context) {
    return BottomBarWithSheet(
      sheetChild: Container(
        height: 100,
        color: Colors.white,
        child: const Center(child: Text("Sheet Content")),
      ),
      items: [
        // Scan/Stop Scan tab (dynamic)
        BottomBarWithSheetItem(
          icon: isScanning ? Icons.stop : Icons.camera_alt,
          label: isScanning ? 'stop_scan' : 'start_scan',
        ),
        // Profile tab
        const BottomBarWithSheetItem(icon: Icons.person, label: 'Profile'),
        // Settings tab
        const BottomBarWithSheetItem(icon: Icons.settings, label: 'Settings'),
        // AI tab
        const BottomBarWithSheetItem(icon: Icons.psychology_alt, label: 'AI'),
        // Notifications tab
        const BottomBarWithSheetItem(
          icon: Icons.notifications,
          label: 'Notifications',
        ),
      ],
      onSelectItem: onItemTap, // Calls parent callback when item is tapped
    );
  }
}
