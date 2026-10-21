import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/launcher_system.dart';

class OmarchyTilingDesktop extends StatelessWidget {
  const OmarchyTilingDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final state = LauncherSystemState();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;

          if (!isWide) {
            // Stacked on small mobile screens
            return Column(
              children: [
                Expanded(child: _buildKittyTerminal(state)),
                const SizedBox(height: 12),
                Expanded(child: _buildNeovimTile(state)),
              ],
            );
          }

          // Side-by-side tiling on tablet / foldable / desktop
          return Row(
            children: [
              Expanded(flex: 5, child: _buildKittyTerminal(state)),
              const SizedBox(width: 14),
              Expanded(flex: 4, child: _buildNeovimTile(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildKittyTerminal(LauncherSystemState state) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xE60D0E15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF00F0FF).withValues(alpha: 0.35),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F0FF).withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Window Header
            Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
              ),
              child: Row(
                children: [
                  const Icon(Icons.terminal_rounded, size: 14, color: Color(0xFF00F0FF)),
                  const SizedBox(width: 8),
                  Text(
                    'kitty : ~ / sovereign-workstation',
                    style: GoogleFonts.jetBrainsMono(fontSize: 10.5, color: Colors.white70),
                  ),
                  const Spacer(),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF00FF9D)),
                  ),
                ],
              ),
            ),

            // Terminal Body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _termLine('systemd[1]: Reached target Graphical Interface (Hyprland 0.56)', Colors.white38),
                      _termLine('iram-agentd: Active and listening on /run/agent.sock (zero-idle-ram)', const Color(0xFF00FF9D)),
                      _termLine('toolgate: Firewall initialized [Hunter/Verifier armed]', const Color(0xFF00F0FF)),
                      const SizedBox(height: 8),
                      Text('\$ neofetch --ascii_distro arch', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _neofetchSpec('OS', 'IRAM OS 26.10 LTS x86_64 / Android Hybrid'),
                      _neofetchSpec('Host', 'apravint sovereign rig (Dual-WAN ECMP)'),
                      _neofetchSpec('Kernel', '6.14.0-iram-zen-cfs'),
                      _neofetchSpec('Uptime', '8 days, 14 hours, 22 mins'),
                      _neofetchSpec('Packages', '1,492 (pacman), 32 (cargo)'),
                      _neofetchSpec('WM', 'Hyprland (Wayland compositor)'),
                      _neofetchSpec('Theme', 'Cyberpunk Neon Palette Studio'),
                      _neofetchSpec('Terminal', 'Kitty with Vulkan Hardware Acceleration'),
                      _neofetchSpec('Memory', '15.4 GB / 31.2 GB (49% used)'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text('\$ ', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: const Color(0xFF00F0FF), fontWeight: FontWeight.bold)),
                          Container(
                            width: 8,
                            height: 14,
                            color: const Color(0xFF00F0FF),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeovimTile(LauncherSystemState state) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xE60D0E15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFBD00FF).withValues(alpha: 0.35),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFBD00FF).withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Window Header
            Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
              ),
              child: Row(
                children: [
                  const Icon(Icons.code_rounded, size: 14, color: Color(0xFFBD00FF)),
                  const SizedBox(width: 8),
                  Text(
                    'nvim : ~/iram-os/hyprland.conf',
                    style: GoogleFonts.jetBrainsMono(fontSize: 10.5, color: Colors.white70),
                  ),
                  const Spacer(),
                  Text('[UTF-8 | Lua]', style: GoogleFonts.jetBrainsMono(fontSize: 9, color: Colors.white38)),
                ],
              ),
            ),

            // Code editor lines
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _codeLine('1', '# Hyprland 0.56 Sovereign Config', const Color(0xFFBD00FF)),
                      _codeLine('2', 'monitor = ,preferred,auto,1.0', Colors.white70),
                      _codeLine('3', 'input { kb_layout = us, sensitivity = 0.0 }', Colors.white70),
                      _codeLine('4', 'general {', Colors.white),
                      _codeLine('5', '    gaps_in = 6', const Color(0xFF00FF9D)),
                      _codeLine('6', '    gaps_out = 12', const Color(0xFF00FF9D)),
                      _codeLine('7', '    border_size = 2', const Color(0xFF00FF9D)),
                      _codeLine('8', '    col.active_border = rgba(00F0FFee)', const Color(0xFF00F0FF)),
                      _codeLine('9', '    col.inactive_border = rgba(10121Aaa)', Colors.white38),
                      _codeLine('10', '}', Colors.white),
                      _codeLine('11', 'bind = SUPER, Return, exec, kitty', const Color(0xFFFFB900)),
                      _codeLine('12', 'bind = SUPER, D, exec, wofi --show drun', const Color(0xFFFFB900)),
                      _codeLine('13', 'bind = SUPER, Q, killactive,', const Color(0xFFFF2D55)),
                    ],
                  ),
                ),
              ),
            ),

            // Quick Launcher Bar at bottom of tile
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _tileActionButton(Icons.rocket_launch_rounded, 'Run Wofi', () => state.toggleCommandRunner()),
                  _tileActionButton(Icons.memory_rounded, 'Diagnostics', () => HapticFeedback.lightImpact()),
                  _tileActionButton(Icons.layers_rounded, 'Workspaces', () => HapticFeedback.lightImpact()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tileActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 12, color: const Color(0xFF00F0FF)),
            const SizedBox(width: 4),
            Text(label, style: GoogleFonts.outfit(fontSize: 10.5, color: Colors.white.withValues(alpha: 0.8))),
          ],
        ),
      ),
    );
  }

  Widget _termLine(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(fontSize: 10, color: color),
      ),
    );
  }

  Widget _neofetchSpec(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF00F0FF)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Colors.white.withValues(alpha: 0.85)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _codeLine(String num, String code, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Text(num, style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Colors.white24)),
          ),
          Expanded(
            child: Text(code, style: GoogleFonts.jetBrainsMono(fontSize: 10, color: color)),
          ),
        ],
      ),
    );
  }
}
