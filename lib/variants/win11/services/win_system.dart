import 'package:flutter/material.dart';

import '../models/win_app_item.dart';

class WinSystemState extends ChangeNotifier {
  static final WinSystemState _instance = WinSystemState._internal();
  factory WinSystemState() => _instance;

  WinSystemState._internal();

  bool _isStartMenuOpen = false;
  bool get isStartMenuOpen => _isStartMenuOpen;

  bool _isActionCenterOpen = false;
  bool get isActionCenterOpen => _isActionCenterOpen;

  bool _isSearchOpen = false;
  bool get isSearchOpen => _isSearchOpen;

  bool _isWidgetsOpen = false;
  bool get isWidgetsOpen => _isWidgetsOpen;

  bool _isExplorerOpen = true;
  bool get isExplorerOpen => _isExplorerOpen;

  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  bool _wifiEnabled = true;
  bool get wifiEnabled => _wifiEnabled;

  bool _bluetoothEnabled = true;
  bool get bluetoothEnabled => _bluetoothEnabled;

  bool _airplaneMode = false;
  bool get airplaneMode => _airplaneMode;

  bool _nightLight = false;
  bool get nightLight => _nightLight;

  bool _batterySaver = false;
  bool get batterySaver => _batterySaver;

  double _brightness = 0.85;
  double get brightness => _brightness;

  double _volume = 0.70;
  double get volume => _volume;

  final Set<String> _runningAppIds = {'explorer', 'edge'};
  Set<String> get runningAppIds => Set.unmodifiable(_runningAppIds);

  static const List<WinAppItem> allApps = [
    WinAppItem(
      id: 'edge',
      name: 'Microsoft Edge',
      category: 'Browser',
      iconData: Icons.language_rounded,
      iconColor: Color(0xFF0078D4),
      packageName: 'com.microsoft.emmx',
      isPinnedTaskbar: true,
      isPinnedStart: true,
    ),
    WinAppItem(
      id: 'explorer',
      name: 'File Explorer',
      category: 'System',
      iconData: Icons.folder_rounded,
      iconColor: Color(0xFFF9A825),
      packageName: 'com.google.android.documentsui',
      isPinnedTaskbar: true,
      isPinnedStart: true,
    ),
    WinAppItem(
      id: 'store',
      name: 'Microsoft Store',
      category: 'Store',
      iconData: Icons.shopping_bag_rounded,
      iconColor: Color(0xFF0078D4),
      packageName: 'com.android.vending',
      isPinnedTaskbar: true,
      isPinnedStart: true,
    ),
    WinAppItem(
      id: 'terminal',
      name: 'Terminal',
      category: 'Developer',
      iconData: Icons.terminal_rounded,
      iconColor: Color(0xFF2B2B2B),
      packageName: 'com.termux',
      isPinnedTaskbar: true,
      isPinnedStart: true,
    ),
    WinAppItem(
      id: 'settings',
      name: 'Settings',
      category: 'System',
      iconData: Icons.settings_rounded,
      iconColor: Color(0xFF757575),
      packageName: 'com.android.settings',
      isPinnedTaskbar: false,
      isPinnedStart: true,
    ),
    WinAppItem(
      id: 'photos',
      name: 'Photos',
      category: 'Media',
      iconData: Icons.photo_library_rounded,
      iconColor: Color(0xFF00BCD4),
      packageName: 'com.google.android.apps.photos',
      isPinnedTaskbar: false,
      isPinnedStart: true,
    ),
    WinAppItem(
      id: 'calculator',
      name: 'Calculator',
      category: 'Utilities',
      iconData: Icons.calculate_rounded,
      iconColor: Color(0xFFFF9800),
      packageName: 'com.google.android.calculator',
      isPinnedTaskbar: false,
      isPinnedStart: true,
    ),
    WinAppItem(
      id: 'word',
      name: 'Word',
      category: 'Productivity',
      iconData: Icons.description_rounded,
      iconColor: Color(0xFF185ABD),
      packageName: 'com.microsoft.office.word',
      isPinnedTaskbar: false,
      isPinnedStart: true,
      isRecommended: true,
    ),
    WinAppItem(
      id: 'excel',
      name: 'Excel',
      category: 'Productivity',
      iconData: Icons.table_chart_rounded,
      iconColor: Color(0xFF107C41),
      packageName: 'com.microsoft.office.excel',
      isPinnedTaskbar: false,
      isPinnedStart: true,
      isRecommended: true,
    ),
    WinAppItem(
      id: 'powerpoint',
      name: 'PowerPoint',
      category: 'Productivity',
      iconData: Icons.slideshow_rounded,
      iconColor: Color(0xFFD83B01),
      packageName: 'com.microsoft.office.powerpoint',
      isPinnedTaskbar: false,
      isPinnedStart: true,
      isRecommended: true,
    ),
    WinAppItem(
      id: 'spotify',
      name: 'Spotify',
      category: 'Entertainment',
      iconData: Icons.music_note_rounded,
      iconColor: Color(0xFF1DB954),
      packageName: 'com.spotify.music',
      isPinnedTaskbar: false,
      isPinnedStart: true,
    ),
    WinAppItem(
      id: 'mail',
      name: 'Mail',
      category: 'Communication',
      iconData: Icons.mail_rounded,
      iconColor: Color(0xFF0078D4),
      packageName: 'com.google.android.gm',
      isPinnedTaskbar: false,
      isPinnedStart: true,
    ),
    WinAppItem(
      id: 'calendar',
      name: 'Calendar',
      category: 'Productivity',
      iconData: Icons.calendar_today_rounded,
      iconColor: Color(0xFF0078D4),
      packageName: 'com.google.android.calendar',
      isPinnedTaskbar: false,
      isPinnedStart: true,
    ),
    WinAppItem(
      id: 'notepad',
      name: 'Notepad',
      category: 'Utilities',
      iconData: Icons.edit_note_rounded,
      iconColor: Color(0xFF0078D4),
      packageName: 'com.google.android.keep',
      isPinnedTaskbar: false,
      isPinnedStart: true,
    ),
  ];

  void launchApp(WinAppItem app) {
    _runningAppIds.add(app.id);
    _isStartMenuOpen = false;
    _isSearchOpen = false;
    _isActionCenterOpen = false;
    _isWidgetsOpen = false;
    if (app.id == 'explorer') {
      _isExplorerOpen = true;
    }
    notifyListeners();
  }

  void toggleStartMenu() {
    _isStartMenuOpen = !_isStartMenuOpen;
    _isActionCenterOpen = false;
    _isSearchOpen = false;
    _isWidgetsOpen = false;
    notifyListeners();
  }

  void toggleActionCenter() {
    _isActionCenterOpen = !_isActionCenterOpen;
    _isStartMenuOpen = false;
    _isSearchOpen = false;
    _isWidgetsOpen = false;
    notifyListeners();
  }

  void toggleSearch() {
    _isSearchOpen = !_isSearchOpen;
    _isStartMenuOpen = false;
    _isActionCenterOpen = false;
    _isWidgetsOpen = false;
    notifyListeners();
  }

  void toggleWidgets() {
    _isWidgetsOpen = !_isWidgetsOpen;
    _isStartMenuOpen = false;
    _isActionCenterOpen = false;
    _isSearchOpen = false;
    notifyListeners();
  }

  void toggleExplorer() {
    _isExplorerOpen = !_isExplorerOpen;
    notifyListeners();
  }

  void closeExplorer() {
    _isExplorerOpen = false;
    notifyListeners();
  }

  void closeOverlays() {
    _isStartMenuOpen = false;
    _isActionCenterOpen = false;
    _isSearchOpen = false;
    _isWidgetsOpen = false;
    notifyListeners();
  }

  void toggleWifi() {
    _wifiEnabled = !_wifiEnabled;
    notifyListeners();
  }

  void toggleBluetooth() {
    _bluetoothEnabled = !_bluetoothEnabled;
    notifyListeners();
  }

  void toggleAirplane() {
    _airplaneMode = !_airplaneMode;
    notifyListeners();
  }

  void toggleNightLight() {
    _nightLight = !_nightLight;
    notifyListeners();
  }

  void toggleBatterySaver() {
    _batterySaver = !_batterySaver;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setBrightness(double v) {
    _brightness = v;
    notifyListeners();
  }

  void setVolume(double v) {
    _volume = v;
    notifyListeners();
  }
}
