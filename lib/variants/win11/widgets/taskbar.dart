import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../services/win_system.dart';

class WinTaskbar extends StatefulWidget {
  const WinTaskbar({super.key});

  @override
  State<WinTaskbar> createState() => _WinTaskbarState();
}

class _WinTaskbarState extends State<WinTaskbar> {
  late Timer _clockTimer;
  late DateTime _currentTime;
  String? _hoveredId;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _currentTime = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = WinSystemState();
    final timeStr = DateFormat('h:mm a').format(_currentTime);
    final dateStr = DateFormat('M/d/yyyy').format(_currentTime);

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final taskbarApps = WinSystemState.allApps
            .where((a) => a.isPinnedTaskbar)
            .toList();

        return Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xF21C1C1F),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.12),
                width: 0.6,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left widget area (e.g. Weather badge on desktop)
              if (MediaQuery.of(context).size.width > 600)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      state.toggleWidgets();
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.wb_sunny_rounded,
                            size: 16,
                            color: Color(0xFFFFB900),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '72°F Sunny',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Centered Taskbar Icon Cluster
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Windows Start Button
                        _buildTaskbarButton(
                          id: 'start',
                          isActive: state.isStartMenuOpen,
                          onTap: () => state.toggleStartMenu(),
                          child: _buildWindowsLogo(state.isStartMenuOpen),
                        ),
                        const SizedBox(width: 4),

                        // Search Button
                        _buildTaskbarButton(
                          id: 'search',
                          isActive: state.isSearchOpen,
                          onTap: () => state.toggleSearch(),
                          child: const Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),

                        // Task View / Desktops Button
                        _buildTaskbarButton(
                          id: 'taskview',
                          isActive: false,
                          onTap: () => HapticFeedback.lightImpact(),
                          child: const Icon(
                            Icons.flip_to_front_rounded,
                            size: 19,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),

                        // Pinned Apps
                        ...taskbarApps.map((app) {
                          final isRunning = state.runningAppIds.contains(
                            app.id,
                          );

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: _buildTaskbarButton(
                              id: app.id,
                              isActive: false,
                              isRunning: isRunning,
                              onTap: () => state.launchApp(app),
                              child: Icon(
                                app.iconData,
                                size: 20,
                                color: app.iconColor,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              // Right System Tray
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Network / Sound / Battery Quick Flyout Trigger
                    InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        state.toggleActionCenter();
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              state.wifiEnabled
                                  ? Icons.wifi_rounded
                                  : Icons.wifi_off_rounded,
                              size: 15,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.volume_up_rounded,
                              size: 15,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              state.batterySaver
                                  ? Icons.battery_saver_rounded
                                  : Icons.battery_full_rounded,
                              size: 15,
                              color: state.batterySaver
                                  ? const Color(0xFFFFB900)
                                  : Colors.white.withValues(alpha: 0.9),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Clock & Date Trigger
                    InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        state.toggleActionCenter();
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              timeStr,
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              dateStr,
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Show Desktop line
                    Container(
                      width: 1,
                      height: 18,
                      margin: const EdgeInsets.only(left: 4),
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWindowsLogo(bool isOpen) {
    return SizedBox(
      width: 18,
      height: 18,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 2.5,
        mainAxisSpacing: 2.5,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          4,
          (i) => Container(
            decoration: BoxDecoration(
              color: isOpen ? const Color(0xFF60CDFF) : const Color(0xFF0078D4),
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskbarButton({
    required String id,
    required bool isActive,
    bool isRunning = false,
    required VoidCallback onTap,
    required Widget child,
  }) {
    final isHovered = _hoveredId == id;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredId = id),
      onExit: (_) => setState(() => _hoveredId = null),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withValues(alpha: 0.16)
                : (isHovered
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              child,
              if (isRunning)
                Positioned(
                  bottom: 2,
                  child: Container(
                    width: 6,
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF60CDFF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
