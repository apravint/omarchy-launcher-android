import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/launcher_system.dart';

class Win11View extends StatelessWidget {
  const Win11View({super.key});

  @override
  Widget build(BuildContext context) {
    final state = LauncherSystemState();
    final timeStr = DateFormat('h:mm a').format(DateTime.now());
    final dateStr = DateFormat('M/d/yyyy').format(DateTime.now());

    return Stack(
      children: [
        // Windows 11 Bloom Wallpaper
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.1),
                radius: 1.1,
                colors: [
                  Color(0xFF005FB8),
                  Color(0xFF003875),
                  Color(0xFF0F1524),
                  Color(0xFF080B10),
                ],
                stops: [0.0, 0.4, 0.75, 1.0],
              ),
            ),
          ),
        ),

        // Desktop Shortcuts
        Positioned(
          top: 48,
          left: 20,
          child: Column(
            children: [
              _desktopShortcut(Icons.delete_outline_rounded, const Color(0xFF60CDFF), 'Recycle Bin'),
              const SizedBox(height: 16),
              _desktopShortcut(Icons.laptop_windows_rounded, const Color(0xFF0078D4), 'This PC'),
              const SizedBox(height: 16),
              _desktopShortcut(Icons.folder_rounded, const Color(0xFFF9A825), 'Projects'),
            ],
          ),
        ),

        // Windows 11 Start Menu Modal
        if (state.isStartMenuOpen)
          Positioned(
            bottom: 56,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 440,
                height: 400,
                decoration: BoxDecoration(
                  color: const Color(0xF2202025),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search box
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 16, color: Colors.white.withValues(alpha: 0.6)),
                          const SizedBox(width: 8),
                          Text(
                            'Type here to search',
                            style: GoogleFonts.outfit(fontSize: 12, color: Colors.white.withValues(alpha: 0.4)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Pinned', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 10),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        children: LauncherSystemState.allApps.take(8).map((app) {
                          return InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              state.launchApp(app);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(app.iconData, size: 24, color: app.iconColor),
                                const SizedBox(height: 4),
                                Text(
                                  app.name,
                                  style: GoogleFonts.outfit(fontSize: 10, color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Windows 11 Centered Taskbar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xF21C1C1F),
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.12))),
            ),
            child: Row(
              children: [
                const Spacer(),
                // Centered icon cluster
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Start button
                    IconButton(
                      icon: const Icon(Icons.window_rounded, size: 20, color: Color(0xFF0078D4)),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        state.toggleStartMenu();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.search_rounded, size: 20, color: Colors.white),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        state.toggleStartMenu();
                      },
                    ),
                    ...LauncherSystemState.allApps.take(4).map((app) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            state.launchApp(app);
                          },
                          child: Container(
                            width: 38,
                            height: 38,
                            alignment: Alignment.center,
                            child: Icon(app.iconData, size: 20, color: app.iconColor),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const Spacer(),

                // System tray
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(timeStr, style: GoogleFonts.outfit(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(dateStr, style: GoogleFonts.outfit(fontSize: 9.5, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _desktopShortcut(IconData icon, Color color, String title) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3)),
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
          child: Text(title, style: GoogleFonts.outfit(fontSize: 10.5, color: Colors.white)),
        ),
      ],
    );
  }
}
