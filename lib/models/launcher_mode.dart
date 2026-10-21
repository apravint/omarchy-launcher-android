import 'package:flutter/material.dart';

enum LauncherMode {
  omarchy('Omarchy Hyprland', Icons.terminal_rounded, Color(0xFF00F0FF)),
  macos('macOS Sonoma', Icons.apple_rounded, Color(0xFFFF2D55)),
  win11('Windows 11', Icons.window_rounded, Color(0xFF0078D4));

  final String label;
  final IconData icon;
  final Color accentColor;

  const LauncherMode(this.label, this.icon, this.accentColor);
}

class LauncherAppItem {
  final String id;
  final String name;
  final String category;
  final IconData iconData;
  final Color iconColor;
  final String command;

  const LauncherAppItem({
    required this.id,
    required this.name,
    required this.category,
    required this.iconData,
    required this.iconColor,
    required this.command,
  });
}
