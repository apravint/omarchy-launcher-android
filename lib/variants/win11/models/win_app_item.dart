import 'package:flutter/material.dart';

class WinAppItem {
  final String id;
  final String name;
  final String category;
  final IconData iconData;
  final Color iconColor;
  final String packageName;
  final bool isPinnedTaskbar;
  final bool isPinnedStart;
  final bool isRecommended;

  const WinAppItem({
    required this.id,
    required this.name,
    required this.category,
    required this.iconData,
    required this.iconColor,
    required this.packageName,
    this.isPinnedTaskbar = false,
    this.isPinnedStart = true,
    this.isRecommended = false,
  });
}
