import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/launcher_system.dart';

class MacOsView extends StatelessWidget {
  const MacOsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = LauncherSystemState();
    final timeStr = DateFormat('EEE d MMM  hh:mm a').format(DateTime.now());

    return Stack(
      children: [
        // Sonoma Ambient Wallpaper
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.4, -0.3),
                radius: 1.2,
                colors: [
                  Color(0xFF2E3192),
                  Color(0xFF1BFFFF),
                  Color(0xFFD4145A),
                  Color(0xFF0F0C29),
                ],
                stops: [0.0, 0.45, 0.8, 1.0],
              ),
            ),
          ),
        ),

        // macOS Top Menu Bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.15), width: 0.5)),
            ),
            child: Row(
              children: [
                const Text('', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text('Finder', style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(width: 14),
                if (MediaQuery.of(context).size.width > 600) ...[
                  _menuItem('File'),
                  _menuItem('Edit'),
                  _menuItem('View'),
                  _menuItem('Go'),
                  _menuItem('Window'),
                  _menuItem('Help'),
                ],
                const Spacer(),
                const Icon(Icons.wifi_rounded, size: 14, color: Colors.white70),
                const SizedBox(width: 10),
                const Icon(Icons.battery_charging_full_rounded, size: 15, color: Colors.white70),
                const SizedBox(width: 10),
                Text(timeStr, style: GoogleFonts.outfit(fontSize: 11, color: Colors.white)),
              ],
            ),
          ),
        ),

        // Desktop Folder Icons
        Positioned(
          top: 48,
          left: 20,
          child: Column(
            children: [
              _desktopIcon(Icons.inventory_2_rounded, const Color(0xFF64B5F6), 'Macintosh HD'),
              const SizedBox(height: 16),
              _desktopIcon(Icons.folder_rounded, const Color(0xFF4FC3F7), 'Projects'),
              const SizedBox(height: 16),
              _desktopIcon(Icons.description_rounded, const Color(0xFFFFB74D), 'Notes.md'),
            ],
          ),
        ),

        // Floating macOS Dock
        Positioned(
          left: 0,
          right: 0,
          bottom: 12,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: LauncherSystemState.allApps.map((app) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          state.launchApp(app);
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: app.iconColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: app.iconColor.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(app.iconData, color: Colors.white, size: 22),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _menuItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        title,
        style: GoogleFonts.outfit(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
      ),
    );
  }

  Widget _desktopIcon(IconData icon, Color color, String title) {
    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(title, style: GoogleFonts.outfit(fontSize: 10.5, color: Colors.white)),
        ),
      ],
    );
  }
}
