import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/win_system.dart';
import '../widgets/action_center.dart';
import '../widgets/file_explorer_window.dart';
import '../widgets/start_menu.dart';
import '../widgets/taskbar.dart';

class WinDesktopScreen extends StatelessWidget {
  const WinDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = WinSystemState();

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final brightness = state.brightness;

        return Scaffold(
          body: Opacity(
            opacity: brightness.clamp(0.4, 1.0),
            child: Stack(
              children: [
                // Windows 11 Bloom Wallpaper Background
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => state.closeOverlays(),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(0.0, -0.1),
                          radius: 1.1,
                          colors: [
                            Color(0xFF005FB8), // Vibrant Windows Bloom Azure
                            Color(0xFF003875), // Deep Bloom Navy
                            Color(0xFF0F1524), // Twilight Indigo
                            Color(0xFF080B10), // Midnight Base
                          ],
                          stops: [0.0, 0.4, 0.75, 1.0],
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.1),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.35),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Desktop Shortcuts (Top Left Column)
                Positioned(
                  top: 24,
                  left: 20,
                  child: Column(
                    children: [
                      _buildDesktopShortcut(
                        icon: Icons.delete_outline_rounded,
                        color: const Color(0xFF60CDFF),
                        title: 'Recycle Bin',
                        onTap: () => HapticFeedback.lightImpact(),
                      ),
                      const SizedBox(height: 18),
                      _buildDesktopShortcut(
                        icon: Icons.laptop_windows_rounded,
                        color: const Color(0xFF0078D4),
                        title: 'This PC',
                        onTap: () => state.toggleExplorer(),
                      ),
                      const SizedBox(height: 18),
                      _buildDesktopShortcut(
                        icon: Icons.language_rounded,
                        color: const Color(0xFF0078D4),
                        title: 'Microsoft Edge',
                        onTap: () => state.launchApp(
                          WinSystemState.allApps.firstWhere(
                            (a) => a.id == 'edge',
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildDesktopShortcut(
                        icon: Icons.folder_rounded,
                        color: const Color(0xFFF9A825),
                        title: 'Projects',
                        onTap: () => state.toggleExplorer(),
                      ),
                      const SizedBox(height: 18),
                      _buildDesktopShortcut(
                        icon: Icons.terminal_rounded,
                        color: const Color(0xFF2B2B2B),
                        title: 'Terminal',
                        onTap: () => state.launchApp(
                          WinSystemState.allApps.firstWhere(
                            (a) => a.id == 'terminal',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Active App Window: File Explorer
                const WinFileExplorerWindow(),

                // Taskbar fixed at the bottom
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: WinTaskbar(),
                ),

                // Flyout Overlays
                const WinStartMenu(),
                const WinActionCenter(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopShortcut({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: SizedBox(
        width: 74,
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 10.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
