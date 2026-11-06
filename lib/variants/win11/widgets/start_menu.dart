import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/win_app_item.dart';
import '../services/win_system.dart';

class WinStartMenu extends StatefulWidget {
  const WinStartMenu({super.key});

  @override
  State<WinStartMenu> createState() => _WinStartMenuState();
}

class _WinStartMenuState extends State<WinStartMenu> {
  final TextEditingController _searchController = TextEditingController();
  bool _showAllApps = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = WinSystemState();

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        if (!state.isStartMenuOpen) return const SizedBox.shrink();

        final screenWidth = MediaQuery.of(context).size.width;
        final cardWidth = screenWidth > 600 ? 560.0 : (screenWidth - 32);

        return Positioned(
          bottom: 56,
          left: (screenWidth - cardWidth) / 2,
          child: Container(
            width: cardWidth,
            height: 580,
            decoration: BoxDecoration(
              color: const Color(0xF5232327),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.16),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 36,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 28, 28, 16),
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.14),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 18,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Search for apps, settings, and documents',
                                hintStyle: GoogleFonts.outfit(
                                  fontSize: 12.5,
                                  color: Colors.white.withValues(alpha: 0.45),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Main Scrollable Area
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pinned Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _showAllApps ? 'All apps' : 'Pinned',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _showAllApps = !_showAllApps);
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _showAllApps ? 'Back' : 'All apps',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: const Color(0xFF60CDFF),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Icon(
                                      _showAllApps
                                          ? Icons.chevron_left_rounded
                                          : Icons.chevron_right_rounded,
                                      size: 14,
                                      color: const Color(0xFF60CDFF),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Pinned Apps Grid
                          _buildAppsGrid(state),

                          const SizedBox(height: 24),

                          // Recommended Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recommended',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'More >',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Recommended Files List
                          _buildRecommendedItem(
                            icon: Icons.code_rounded,
                            iconColor: const Color(0xFF0078D4),
                            title: 'mira-math-android.dart',
                            time: '17m ago',
                          ),
                          _buildRecommendedItem(
                            icon: Icons.insert_chart_rounded,
                            iconColor: const Color(0xFF107C41),
                            title: 'Spend_Summary_Q3.xlsx',
                            time: '2h ago',
                          ),
                          _buildRecommendedItem(
                            icon: Icons.article_rounded,
                            iconColor: const Color(0xFFFFB900),
                            title: 'IRAM_OS_Architecture.pdf',
                            time: 'Yesterday at 8:45 PM',
                          ),
                          _buildRecommendedItem(
                            icon: Icons.terminal_rounded,
                            iconColor: const Color(0xFF60CDFF),
                            title: 'quick_benchmark.sh',
                            time: '2 days ago',
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Profile & Power Footer
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // User Profile
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF0078D4),
                                    Color(0xFF60CDFF),
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'AP',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Ayyappa Pravin',
                              style: GoogleFonts.outfit(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        // Power Button
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.power_settings_new_rounded,
                            size: 20,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                          color: const Color(0xF0252528),
                          offset: const Offset(0, -110),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          onSelected: (val) {
                            HapticFeedback.lightImpact();
                            state.toggleStartMenu();
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'sleep',
                              child: Text(
                                'Sleep',
                                style: TextStyle(fontSize: 12.5),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'shutdown',
                              child: Text(
                                'Shut down',
                                style: TextStyle(fontSize: 12.5),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'restart',
                              child: Text(
                                'Restart',
                                style: TextStyle(fontSize: 12.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppsGrid(WinSystemState state) {
    final query = _searchController.text.trim().toLowerCase();
    final apps = WinSystemState.allApps.where((a) {
      if (!_showAllApps && !a.isPinnedStart) return false;
      if (query.isEmpty) return true;
      return a.name.toLowerCase().contains(query) ||
          a.category.toLowerCase().contains(query);
    }).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: apps.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, i) {
        final app = apps[i];
        return _buildAppTile(app, () => state.launchApp(app));
      },
    );
  }

  Widget _buildAppTile(WinAppItem app, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: app.iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: app.iconColor.withValues(alpha: 0.3)),
            ),
            child: Icon(app.iconData, size: 20, color: app.iconColor),
          ),
          const SizedBox(height: 5),
          Text(
            app.name,
            style: GoogleFonts.outfit(
              fontSize: 10.5,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  time,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
