import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/win_system.dart';

class WinActionCenter extends StatelessWidget {
  const WinActionCenter({super.key});

  @override
  Widget build(BuildContext context) {
    final state = WinSystemState();

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        if (!state.isActionCenterOpen) return const SizedBox.shrink();

        return Positioned(
          bottom: 56,
          right: 12,
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xF5242428),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.16),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick settings 2x3 grid
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.15,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _quickToggle(
                      icon: Icons.wifi_rounded,
                      label: 'Wi-Fi',
                      subtitle: state.wifiEnabled ? 'Connected' : 'Off',
                      isActive: state.wifiEnabled,
                      onTap: state.toggleWifi,
                    ),
                    _quickToggle(
                      icon: Icons.bluetooth_rounded,
                      label: 'Bluetooth',
                      subtitle: state.bluetoothEnabled ? 'On' : 'Off',
                      isActive: state.bluetoothEnabled,
                      onTap: state.toggleBluetooth,
                    ),
                    _quickToggle(
                      icon: Icons.airplanemode_active_rounded,
                      label: 'Airplane',
                      subtitle: state.airplaneMode ? 'On' : 'Off',
                      isActive: state.airplaneMode,
                      onTap: state.toggleAirplane,
                    ),
                    _quickToggle(
                      icon: Icons.battery_saver_rounded,
                      label: 'Battery Saver',
                      subtitle: state.batterySaver ? 'On' : 'Off',
                      isActive: state.batterySaver,
                      onTap: state.toggleBatterySaver,
                    ),
                    _quickToggle(
                      icon: Icons.nightlight_round,
                      label: 'Night light',
                      subtitle: state.nightLight ? 'On' : 'Off',
                      isActive: state.nightLight,
                      onTap: state.toggleNightLight,
                    ),
                    _quickToggle(
                      icon: Icons.dark_mode_rounded,
                      label: 'Dark theme',
                      subtitle: state.isDarkMode ? 'Dark' : 'Light',
                      isActive: state.isDarkMode,
                      onTap: state.toggleDarkMode,
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Brightness Slider
                Row(
                  children: [
                    Icon(
                      Icons.wb_sunny_rounded,
                      size: 18,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFF0078D4),
                          inactiveTrackColor: Colors.white.withValues(
                            alpha: 0.15,
                          ),
                          thumbColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 7,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 14,
                          ),
                        ),
                        child: Slider(
                          value: state.brightness,
                          onChanged: (v) => state.setBrightness(v),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Volume Slider
                Row(
                  children: [
                    Icon(
                      Icons.volume_up_rounded,
                      size: 18,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFF0078D4),
                          inactiveTrackColor: Colors.white.withValues(
                            alpha: 0.15,
                          ),
                          thumbColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 7,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 14,
                          ),
                        ),
                        child: Slider(
                          value: state.volume,
                          onChanged: (v) => state.setVolume(v),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0x22FFFFFF)),
                const SizedBox(height: 10),

                // Battery and Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.battery_charging_full_rounded,
                            size: 18,
                            color: Color(0xFF60CDFF),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '94% • Battery Healthy',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings_rounded,
                        size: 18,
                        color: Colors.white70,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        state.toggleActionCenter();
                        state.launchApp(
                          WinSystemState.allApps.firstWhere(
                            (a) => a.id == 'settings',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _quickToggle({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF0078D4)
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive
                ? const Color(0xFF60CDFF).withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.85),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 9,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
