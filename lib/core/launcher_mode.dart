import 'package:flutter/material.dart';

/// The three OS-style variants this launcher ships.
///
/// Each value maps 1:1 to an Android product flavor (see `android/app/build.gradle.kts`)
/// and to a legacy single-purpose repository.
enum LauncherMode {
  omarchy(
    flavor: 'omarchy',
    label: 'Omarchy Hyprland',
    icon: Icons.terminal_rounded,
    accentColor: Color(0xFF00F0FF),
  ),
  macos(
    flavor: 'macos',
    label: 'macOS Sonoma',
    icon: Icons.apple_rounded,
    accentColor: Color(0xFFFF2D55),
  ),
  win11(
    flavor: 'win11',
    label: 'Windows 11',
    icon: Icons.window_rounded,
    accentColor: Color(0xFF0078D4),
  );

  /// Android product flavor name, also reported by Flutter's `appFlavor`.
  final String flavor;
  final String label;
  final IconData icon;
  final Color accentColor;

  const LauncherMode({
    required this.flavor,
    required this.label,
    required this.icon,
    required this.accentColor,
  });

  /// Resolves the variant for a flavor name. Unknown or missing flavors
  /// (e.g. `flutter run` without `--flavor`, web, tests) fall back to [omarchy].
  static LauncherMode fromFlavor(String? flavor) {
    for (final mode in values) {
      if (mode.flavor == flavor) return mode;
    }
    return LauncherMode.omarchy;
  }
}
