import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/launcher_system.dart';

class OmarchyWaybar extends StatefulWidget {
  const OmarchyWaybar({super.key});

  @override
  State<OmarchyWaybar> createState() => _OmarchyWaybarState();
}

class _OmarchyWaybarState extends State<OmarchyWaybar> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = LauncherSystemState();
    final timeStr = DateFormat('EEE d MMM  hh:mm:ss a').format(_now);

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xEE0B0D14),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFF00F0FF).withValues(alpha: 0.25),
                width: 0.8,
              ),
            ),
          ),
          child: Row(
            children: [
              // Distro Logo + Workspaces [1][2][3][4][5]
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF00F0FF).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.hub_rounded, size: 14, color: Color(0xFF00F0FF)),
              ),
              const SizedBox(width: 8),

              // Workspaces
              ...List.generate(5, (i) {
                final ws = i + 1;
                final isActive = state.activeWorkspace == ws;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    state.setWorkspace(ws);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF00F0FF) : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$ws',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.black : Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 12),

              // Active Window Title
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00FF9D),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        state.activeWindowTitle,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // System Telemetry (CPU, RAM, Battery, Clock)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _telemetryBadge(Icons.memory_rounded, 'CPU ${(state.cpuUsage * 100).toInt()}%', const Color(0xFF00F0FF)),
                  const SizedBox(width: 6),
                  _telemetryBadge(Icons.storage_rounded, 'RAM ${(state.ramUsage * 100).toInt()}%', const Color(0xFFBD00FF)),
                  const SizedBox(width: 6),
                  _telemetryBadge(Icons.battery_charging_full_rounded, '${state.batteryLevel}%', const Color(0xFF00FF9D)),
                  const SizedBox(width: 8),
                  Text(
                    timeStr,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10.5,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Wofi Runner Trigger
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      state.toggleCommandRunner();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00F0FF).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFF00F0FF).withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.rocket_launch_rounded, size: 12, color: Color(0xFF00F0FF)),
                          const SizedBox(width: 4),
                          Text(
                            'Wofi',
                            style: GoogleFonts.outfit(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF00F0FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _telemetryBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
