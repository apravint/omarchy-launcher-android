import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/launcher_mode.dart';
import '../services/launcher_system.dart';

class OmarchyCommandRunner extends StatefulWidget {
  const OmarchyCommandRunner({super.key});

  @override
  State<OmarchyCommandRunner> createState() => _OmarchyCommandRunnerState();
}

class _OmarchyCommandRunnerState extends State<OmarchyCommandRunner> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = LauncherSystemState();

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        if (!state.isCommandRunnerOpen) return const SizedBox.shrink();

        final query = _searchController.text.trim().toLowerCase();
        final filteredApps = LauncherSystemState.allApps.where((a) {
          if (query.isEmpty) return true;
          return a.name.toLowerCase().contains(query) ||
              a.command.toLowerCase().contains(query) ||
              a.category.toLowerCase().contains(query);
        }).toList();

        return Positioned.fill(
          child: GestureDetector(
            onTap: state.toggleCommandRunner,
            child: Container(
              color: Colors.black.withValues(alpha: 0.65),
              child: Center(
                child: GestureDetector(
                  onTap: () {}, // Prevent closing when clicking modal
                  child: Container(
                    width: 480,
                    margin: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xF510121C),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF00F0FF),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00F0FF).withValues(alpha: 0.3),
                          blurRadius: 28,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Search bar
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              const Text('>', style: TextStyle(color: Color(0xFF00F0FF), fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  autofocus: true,
                                  style: GoogleFonts.jetBrainsMono(fontSize: 13, color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Search applications or type bash command...',
                                    hintStyle: GoogleFonts.jetBrainsMono(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.35),
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              if (_searchController.text.isNotEmpty)
                                GestureDetector(
                                  onTap: () => setState(() => _searchController.clear()),
                                  child: const Icon(Icons.close, size: 16, color: Colors.white54),
                                ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Color(0x3300F0FF)),

                        // App list
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 320),
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: filteredApps.length,
                            separatorBuilder: (_, _) => const Divider(height: 1, color: Color(0x14FFFFFF)),
                            itemBuilder: (context, i) {
                              final app = filteredApps[i];
                              return _appRow(app, () {
                                HapticFeedback.lightImpact();
                                state.launchApp(app);
                              });
                            },
                          ),
                        ),

                        // Footer hint
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${filteredApps.length} entries • [Super + D]',
                                style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Colors.white.withValues(alpha: 0.4)),
                              ),
                              Text(
                                'IRAM OS Hyprland',
                                style: GoogleFonts.outfit(fontSize: 10, color: const Color(0xFF00F0FF)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _appRow(LauncherAppItem app, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: app.iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: app.iconColor.withValues(alpha: 0.3)),
              ),
              child: Icon(app.iconData, size: 18, color: app.iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app.name,
                    style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  Text(
                    '${app.command} • ${app.category}',
                    style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Colors.white.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
