import 'package:flutter/foundation.dart';

import '../variants/macos/services/mac_system.dart';
import '../variants/omarchy/omarchy_state.dart';
import '../variants/win11/services/win_system.dart';
import 'launcher_mode.dart';

/// Holds which variant is on screen and whether the user may switch between
/// variants at runtime.
///
/// The `omarchy` flavor is the "Multi-OS" build and shows the mode switcher.
/// The `win11` and `macos` flavors are locked to their own variant.
class LauncherController extends ChangeNotifier {
  LauncherController({
    LauncherMode initial = LauncherMode.omarchy,
    bool? switchable,
  }) : _mode = initial,
       switchable = switchable ?? initial == LauncherMode.omarchy;

  /// Process-wide instance, configured once in `main()`.
  static LauncherController instance = LauncherController();

  LauncherMode _mode;
  LauncherMode get mode => _mode;

  /// Whether the in-app mode switcher pill is available.
  final bool switchable;

  /// Selects [next]; ignored when not [switchable]. Closes any open overlay
  /// (start menu, launchpad, command runner, ...) in every variant.
  void select(LauncherMode next) {
    if (!switchable || next == _mode) return;
    _mode = next;
    OmarchyState().closeOverlays();
    WinSystemState().closeOverlays();
    MacSystemState().closeOverlays();
    notifyListeners();
  }
}
