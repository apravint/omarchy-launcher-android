import 'package:flutter_test/flutter_test.dart';
import 'package:omarchy_launcher/variants/macos/services/mac_system.dart';
import 'package:omarchy_launcher/variants/omarchy/omarchy_state.dart';
import 'package:omarchy_launcher/variants/win11/services/win_system.dart';

void main() {
  group('OmarchyState', () {
    final state = OmarchyState();
    setUp(state.closeOverlays);

    test('is a singleton', () {
      expect(identical(OmarchyState(), state), isTrue);
    });

    test('overlays are mutually exclusive', () {
      state.toggleCommandRunner();
      expect(state.isCommandRunnerOpen, isTrue);
      state.toggleStartMenu();
      expect(state.isStartMenuOpen, isTrue);
      expect(state.isCommandRunnerOpen, isFalse);
      state.toggleLaunchpad();
      expect(state.isLaunchpadOpen, isTrue);
      expect(state.isStartMenuOpen, isFalse);
      state.closeOverlays();
      expect(state.isLaunchpadOpen, isFalse);
    });

    test('launchApp updates the window title and closes overlays', () {
      final app = OmarchyState.allApps.firstWhere((a) => a.id == 'nvim');
      state.toggleCommandRunner();
      state.launchApp(app);
      expect(state.activeWindowTitle, 'nvim • Neovim Editor');
      expect(state.isCommandRunnerOpen, isFalse);
    });

    test('app ids are unique', () {
      final ids = OmarchyState.allApps.map((a) => a.id);
      expect(ids.toSet().length, ids.length);
    });

    test('setWorkspace and toggleWifi notify', () {
      var notified = 0;
      void listener() => notified++;
      state.addListener(listener);
      final wifi = state.wifiEnabled;
      state.setWorkspace(3);
      state.toggleWifi();
      state.toggleWifi();
      state.removeListener(listener);
      expect(state.activeWorkspace, 3);
      expect(state.wifiEnabled, wifi);
      expect(notified, 3);
    });
  });

  group('WinSystemState', () {
    final state = WinSystemState();
    setUp(state.closeOverlays);

    test('start menu and action center are mutually exclusive', () {
      state.toggleStartMenu();
      expect(state.isStartMenuOpen, isTrue);
      state.toggleActionCenter();
      expect(state.isActionCenterOpen, isTrue);
      expect(state.isStartMenuOpen, isFalse);
      state.closeOverlays();
      expect(state.isActionCenterOpen, isFalse);
    });

    test('launching explorer marks it running and opens the window', () {
      final explorer = WinSystemState.allApps.firstWhere(
        (a) => a.id == 'explorer',
      );
      state.toggleStartMenu();
      state.launchApp(explorer);
      expect(state.runningAppIds, contains('explorer'));
      expect(state.isExplorerOpen, isTrue);
      expect(state.isStartMenuOpen, isFalse);
      state.closeExplorer();
      expect(state.isExplorerOpen, isFalse);
    });

    test('quick toggles flip and flip back', () {
      final dark = state.isDarkMode;
      state.toggleDarkMode();
      expect(state.isDarkMode, !dark);
      state.toggleDarkMode();
      expect(state.isDarkMode, dark);
    });

    test('runningAppIds is unmodifiable', () {
      expect(() => state.runningAppIds.add('x'), throwsUnsupportedError);
    });
  });

  group('MacSystemState', () {
    final state = MacSystemState();
    setUp(state.closeOverlays);

    test('control center and about dialog are mutually exclusive', () {
      state.toggleControlCenter();
      expect(state.isControlCenterOpen, isTrue);
      state.toggleAboutMac();
      expect(state.isAboutMacOpen, isTrue);
      expect(state.isControlCenterOpen, isFalse);
    });

    test('launching the launchpad item toggles Launchpad only', () {
      final launchpad = MacSystemState.allApps.firstWhere(
        (a) => a.id == 'launchpad',
      );
      final before = state.activeAppName;
      state.launchApp(launchpad);
      expect(state.isLaunchpadOpen, isTrue);
      expect(state.activeAppName, before);
    });

    test('launching an app sets the active app and marks it running', () {
      final safari = MacSystemState.allApps.firstWhere((a) => a.id == 'safari');
      state.toggleLaunchpad();
      state.launchApp(safari);
      expect(state.activeAppName, 'Safari');
      expect(state.runningAppIds, contains('safari'));
      expect(state.isLaunchpadOpen, isFalse);
    });

    test('brightness and volume setters store the value', () {
      state.setBrightness(0.3);
      state.setVolume(0.1);
      expect(state.brightness, 0.3);
      expect(state.volume, 0.1);
    });
  });
}
