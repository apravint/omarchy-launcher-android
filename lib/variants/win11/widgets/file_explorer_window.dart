import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/win_system.dart';

class WinFileExplorerWindow extends StatefulWidget {
  const WinFileExplorerWindow({super.key});

  @override
  State<WinFileExplorerWindow> createState() => _WinFileExplorerWindowState();
}

class _WinFileExplorerWindowState extends State<WinFileExplorerWindow> {
  String _currentFolder = 'Projects';

  @override
  Widget build(BuildContext context) {
    final state = WinSystemState();

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        if (!state.isExplorerOpen) return const SizedBox.shrink();

        return Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 36, 40, 80),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xF21F1F24),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.16),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.55),
                    blurRadius: 36,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  children: [
                    // Titlebar with Tab & Window Controls
                    _buildTitleBar(state),

                    // Command Bar (New, Cut, Copy, Sort, View)
                    _buildCommandBar(),

                    // Address Bar
                    _buildAddressBar(),

                    // Explorer Body (Sidebar + Content Grid)
                    Expanded(
                      child: Row(
                        children: [
                          _buildSidebar(),
                          Expanded(child: _buildFolderContent()),
                        ],
                      ),
                    ),

                    // Status Bar
                    _buildStatusBar(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleBar(WinSystemState state) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          // Tab
          Container(
            height: 34,
            margin: const EdgeInsets.only(left: 8, top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF2B2B30),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(6),
              ),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                left: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                right: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.folder_rounded,
                  size: 16,
                  color: Color(0xFFF9A825),
                ),
                const SizedBox(width: 8),
                Text(
                  _currentFolder,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.close,
                  size: 12,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.add, size: 14, color: Colors.white.withValues(alpha: 0.5)),
          const Spacer(),

          // Windows Caption Buttons
          _captionButton(
            icon: Icons.minimize,
            onTap: () => HapticFeedback.lightImpact(),
          ),
          _captionButton(
            icon: Icons.crop_square_rounded,
            onTap: () => HapticFeedback.lightImpact(),
          ),
          _captionButton(
            icon: Icons.close_rounded,
            isClose: true,
            onTap: () {
              HapticFeedback.lightImpact();
              state.closeExplorer();
            },
          ),
        ],
      ),
    );
  }

  Widget _captionButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isClose = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 38,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 14,
          color: Colors.white.withValues(alpha: 0.75),
        ),
      ),
    );
  }

  Widget _buildCommandBar() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          _ribbonItem(Icons.add_circle_outline_rounded, 'New ▾'),
          const SizedBox(width: 8),
          _ribbonDivider(),
          const SizedBox(width: 8),
          _ribbonIcon(Icons.content_cut_rounded, 'Cut'),
          _ribbonIcon(Icons.content_copy_rounded, 'Copy'),
          _ribbonIcon(Icons.content_paste_rounded, 'Paste'),
          _ribbonIcon(Icons.drive_file_rename_outline_rounded, 'Rename'),
          _ribbonIcon(Icons.share_rounded, 'Share'),
          _ribbonIcon(Icons.delete_outline_rounded, 'Delete'),
          const SizedBox(width: 8),
          _ribbonDivider(),
          const SizedBox(width: 8),
          _ribbonItem(Icons.sort_rounded, 'Sort ▾'),
          const SizedBox(width: 8),
          _ribbonItem(Icons.grid_view_rounded, 'View ▾'),
        ],
      ),
    );
  }

  Widget _ribbonItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF60CDFF)),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }

  Widget _ribbonIcon(IconData icon, String tooltip) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.7)),
    );
  }

  Widget _ribbonDivider() {
    return Container(
      width: 1,
      height: 16,
      color: Colors.white.withValues(alpha: 0.12),
    );
  }

  Widget _buildAddressBar() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_rounded,
            size: 16,
            color: Colors.white.withValues(alpha: 0.4),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_rounded,
            size: 16,
            color: Colors.white.withValues(alpha: 0.4),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_upward_rounded,
            size: 16,
            color: Colors.white.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 12),

          // Breadcrumb Pill
          Expanded(
            child: Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.laptop_windows_rounded,
                    size: 14,
                    color: Color(0xFF0078D4),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'This PC > Local Disk (C:) > Projects > ',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    _currentFolder,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Search Box
          Container(
            width: 180,
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Search $_currentFolder',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                Icon(
                  Icons.search,
                  size: 14,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.15),
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sidebarItem(Icons.home_rounded, 'Home'),
          _sidebarItem(Icons.computer_rounded, 'Desktop'),
          _sidebarItem(Icons.download_rounded, 'Downloads'),
          _sidebarItem(Icons.description_rounded, 'Documents'),
          _sidebarItem(Icons.folder_shared_rounded, 'Projects'),
          _sidebarItem(Icons.photo_library_rounded, 'Pictures'),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'THIS PC',
              style: GoogleFonts.outfit(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                color: Colors.white.withValues(alpha: 0.4),
                letterSpacing: 0.5,
              ),
            ),
          ),
          _sidebarItem(Icons.storage_rounded, 'Local Disk (C:)'),
          _sidebarItem(Icons.disc_full_rounded, 'Volume (D:)'),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label) {
    final isSelected = _currentFolder == label;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _currentFolder = label);
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected
                  ? const Color(0xFF60CDFF)
                  : Colors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: [
          _fileCard(
            Icons.folder_rounded,
            const Color(0xFFF9A825),
            'Flutter Projects',
            '6 items',
          ),
          _fileCard(
            Icons.folder_rounded,
            const Color(0xFFF9A825),
            'IRAM OS Suite',
            '18 items',
          ),
          _fileCard(
            Icons.folder_rounded,
            const Color(0xFFF9A825),
            'AI Agents',
            '4 repos',
          ),
          _fileCard(
            Icons.code_rounded,
            const Color(0xFF0078D4),
            'mira_math.dart',
            '14.2 KB',
          ),
          _fileCard(
            Icons.table_chart_rounded,
            const Color(0xFF107C41),
            'spend_analysis.csv',
            '88.5 KB',
          ),
          _fileCard(
            Icons.picture_as_pdf_rounded,
            const Color(0xFFD83B01),
            'architecture_spec.pdf',
            '2.4 MB',
          ),
          _fileCard(
            Icons.terminal_rounded,
            const Color(0xFF60CDFF),
            'deploy_launcher.sh',
            '1.1 KB',
          ),
          _fileCard(
            Icons.article_rounded,
            const Color(0xFFFFB900),
            'README.md',
            '4.8 KB',
          ),
        ],
      ),
    );
  }

  Widget _fileCard(IconData icon, Color color, String name, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 38, color: color),
          const SizedBox(height: 6),
          Text(
            name,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.outfit(
              fontSize: 9.5,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '8 items',
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          Text(
            'Local Disk (C:) Free Space: 742 GB of 1 TB',
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
