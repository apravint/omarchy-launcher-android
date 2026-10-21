import 'package:flutter/material.dart';
import '../models/launcher_mode.dart';
import '../services/launcher_system.dart';
import '../widgets/macos_view.dart';
import '../widgets/mode_switcher_pill.dart';
import '../widgets/omarchy_command_runner.dart';
import '../widgets/omarchy_tiling_desktop.dart';
import '../widgets/omarchy_waybar.dart';
import '../widgets/win11_view.dart';

class MultiOsScreen extends StatelessWidget {
  const MultiOsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = LauncherSystemState();

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return Scaffold(
          body: Stack(
            children: [
              // Active OS Desktop View
              Positioned.fill(
                child: _buildOsView(state.currentMode),
              ),

              // Floating Mode Switcher Pill
              const Positioned(
                top: 42,
                left: 0,
                right: 0,
                child: Center(
                  child: ModeSwitcherPill(),
                ),
              ),

              // Wofi Command Runner (for Omarchy mode)
              if (state.currentMode == LauncherMode.omarchy)
                const OmarchyCommandRunner(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOsView(LauncherMode mode) {
    switch (mode) {
      case LauncherMode.omarchy:
        return const Stack(
          children: [
            Positioned(top: 0, left: 0, right: 0, child: OmarchyWaybar()),
            Positioned.fill(child: OmarchyTilingDesktop()),
          ],
        );
      case LauncherMode.macos:
        return const MacOsView();
      case LauncherMode.win11:
        return const Win11View();
    }
  }
}
