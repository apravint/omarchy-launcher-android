import 'package:flutter/material.dart';

import 'core/launcher_controller.dart';
import 'core/launcher_mode.dart';
import 'shared/mode_switcher_pill.dart';
import 'variants/macos/screens/desktop_screen.dart';
import 'variants/macos/services/mac_system.dart';
import 'variants/macos/theme/app_theme.dart';
import 'variants/omarchy/omarchy_theme.dart';
import 'variants/omarchy/widgets/omarchy_command_runner.dart';
import 'variants/omarchy/widgets/omarchy_tiling_desktop.dart';
import 'variants/omarchy/widgets/omarchy_waybar.dart';
import 'variants/win11/screens/desktop_screen.dart';
import 'variants/win11/services/win_system.dart';
import 'variants/win11/theme/win_theme.dart';

/// Root widget shared by every flavor. The active [LauncherMode] decides which
/// theme and desktop are shown.
class LauncherApp extends StatelessWidget {
  const LauncherApp({super.key, this.controller});

  /// Defaults to [LauncherController.instance].
  final LauncherController? controller;

  @override
  Widget build(BuildContext context) {
    final controller = this.controller ?? LauncherController.instance;

    return ListenableBuilder(
      listenable: Listenable.merge([
        controller,
        WinSystemState(),
        MacSystemState(),
      ]),
      builder: (context, _) {
        final mode = controller.mode;
        return MaterialApp(
          title: titleFor(mode, switchable: controller.switchable),
          debugShowCheckedModeBanner: false,
          theme: themeFor(mode),
          home: LauncherHome(controller: controller),
        );
      },
    );
  }

  /// Window/task-switcher title for [mode].
  static String titleFor(LauncherMode mode, {required bool switchable}) {
    if (switchable) return 'Omarchy Multi-OS Launcher';
    switch (mode) {
      case LauncherMode.omarchy:
        return 'Omarchy Launcher';
      case LauncherMode.macos:
        return 'macOS Sonoma Launcher';
      case LauncherMode.win11:
        return 'Windows 11 Launcher';
    }
  }

  /// Material theme for [mode]; the Windows and macOS variants honor their
  /// own light/dark toggle.
  static ThemeData themeFor(LauncherMode mode) {
    switch (mode) {
      case LauncherMode.omarchy:
        return OmarchyTheme.theme();
      case LauncherMode.macos:
        return MacSystemState().isDarkMode
            ? MacTheme.darkTheme()
            : MacTheme.lightTheme();
      case LauncherMode.win11:
        return WinSystemState().isDarkMode
            ? WinTheme.darkTheme()
            : WinTheme.lightTheme();
    }
  }
}

class LauncherHome extends StatelessWidget {
  const LauncherHome({super.key, required this.controller});

  final LauncherController controller;

  @override
  Widget build(BuildContext context) {
    final mode = controller.mode;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned.fill(child: _desktopFor(mode)),
          if (controller.switchable)
            Positioned(
              top: 42,
              left: 0,
              right: 0,
              child: Center(child: ModeSwitcherPill(controller: controller)),
            ),
          if (mode == LauncherMode.omarchy) const OmarchyCommandRunner(),
        ],
      ),
    );
  }

  Widget _desktopFor(LauncherMode mode) {
    switch (mode) {
      case LauncherMode.omarchy:
        return const Scaffold(
          body: Stack(
            children: [
              Positioned(top: 0, left: 0, right: 0, child: OmarchyWaybar()),
              Positioned.fill(child: OmarchyTilingDesktop()),
            ],
          ),
        );
      case LauncherMode.macos:
        return const MacDesktopScreen();
      case LauncherMode.win11:
        return const WinDesktopScreen();
    }
  }
}
