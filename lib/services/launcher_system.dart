import 'package:flutter/material.dart';
import '../models/launcher_mode.dart';

class LauncherSystemState extends ChangeNotifier {
  static final LauncherSystemState _instance = LauncherSystemState._internal();
  factory LauncherSystemState() => _instance;

  LauncherSystemState._internal();

  LauncherMode _currentMode = LauncherMode.omarchy;
  LauncherMode get currentMode => _currentMode;

  int _activeWorkspace = 1;
  int get activeWorkspace => _activeWorkspace;

  bool _isCommandRunnerOpen = false;
  bool get isCommandRunnerOpen => _isCommandRunnerOpen;

  bool _isStartMenuOpen = false;
  bool get isStartMenuOpen => _isStartMenuOpen;

  bool _isLaunchpadOpen = false;
  bool get isLaunchpadOpen => _isLaunchpadOpen;

  final double _cpuUsage = 0.32;
  double get cpuUsage => _cpuUsage;

  final double _ramUsage = 0.45;
  double get ramUsage => _ramUsage;

  final int _batteryLevel = 92;
  int get batteryLevel => _batteryLevel;

  bool _wifiEnabled = true;
  bool get wifiEnabled => _wifiEnabled;

  double _volume = 0.75;
  double get volume => _volume;

  double _brightness = 0.90;
  double get brightness => _brightness;

  String _activeWindowTitle = 'nvim ~/iram-os/config.hypr';
  String get activeWindowTitle => _activeWindowTitle;

  static const List<LauncherAppItem> allApps = [
    LauncherAppItem(
      id: 'terminal',
      name: 'Kitty Terminal',
      category: 'Developer',
      iconData: Icons.terminal_rounded,
      iconColor: Color(0xFF00F0FF),
      command: 'kitty',
    ),
    LauncherAppItem(
      id: 'nvim',
      name: 'Neovim Editor',
      category: 'Developer',
      iconData: Icons.code_rounded,
      iconColor: Color(0xFF00FF9D),
      command: 'nvim',
    ),
    LauncherAppItem(
      id: 'browser',
      name: 'Mira Browser',
      category: 'Internet',
      iconData: Icons.language_rounded,
      iconColor: Color(0xFFBD00FF),
      command: 'chromium-browser',
    ),
    LauncherAppItem(
      id: 'agenthub',
      name: 'Agent Swarm Hub',
      category: 'AI & Agents',
      iconData: Icons.psychology_rounded,
      iconColor: Color(0xFFFF0055),
      command: 'openrig gui',
    ),
    LauncherAppItem(
      id: 'threejs',
      name: 'IRAM 3D Studio',
      category: 'Graphics',
      iconData: Icons.view_in_ar_rounded,
      iconColor: Color(0xFFFFB900),
      command: 'iram-3d',
    ),
    LauncherAppItem(
      id: 'files',
      name: 'File Manager',
      category: 'System',
      iconData: Icons.folder_rounded,
      iconColor: Color(0xFF0078D4),
      command: 'thunar',
    ),
    LauncherAppItem(
      id: 'music',
      name: 'Audio Player',
      category: 'Media',
      iconData: Icons.music_note_rounded,
      iconColor: Color(0xFFFA233B),
      command: 'spotify',
    ),
    LauncherAppItem(
      id: 'settings',
      name: 'System Config',
      category: 'System',
      iconData: Icons.settings_rounded,
      iconColor: Color(0xFF8E8E93),
      command: 'hypr-theme-studio',
    ),
  ];

  void setMode(LauncherMode mode) {
    _currentMode = mode;
    _isCommandRunnerOpen = false;
    _isStartMenuOpen = false;
    _isLaunchpadOpen = false;
    notifyListeners();
  }

  void setWorkspace(int index) {
    _activeWorkspace = index;
    notifyListeners();
  }

  void toggleCommandRunner() {
    _isCommandRunnerOpen = !_isCommandRunnerOpen;
    _isStartMenuOpen = false;
    _isLaunchpadOpen = false;
    notifyListeners();
  }

  void toggleStartMenu() {
    _isStartMenuOpen = !_isStartMenuOpen;
    _isCommandRunnerOpen = false;
    _isLaunchpadOpen = false;
    notifyListeners();
  }

  void toggleLaunchpad() {
    _isLaunchpadOpen = !_isLaunchpadOpen;
    _isCommandRunnerOpen = false;
    _isStartMenuOpen = false;
    notifyListeners();
  }

  void closeOverlays() {
    _isCommandRunnerOpen = false;
    _isStartMenuOpen = false;
    _isLaunchpadOpen = false;
    notifyListeners();
  }

  void launchApp(LauncherAppItem app) {
    _activeWindowTitle = '${app.command} • ${app.name}';
    _isCommandRunnerOpen = false;
    _isStartMenuOpen = false;
    _isLaunchpadOpen = false;
    notifyListeners();
  }

  void toggleWifi() {
    _wifiEnabled = !_wifiEnabled;
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
