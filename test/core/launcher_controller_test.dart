import 'package:flutter_test/flutter_test.dart';
import 'package:omarchy_launcher/core/launcher_controller.dart';
import 'package:omarchy_launcher/core/launcher_mode.dart';
import 'package:omarchy_launcher/variants/macos/services/mac_system.dart';
import 'package:omarchy_launcher/variants/omarchy/omarchy_state.dart';
import 'package:omarchy_launcher/variants/win11/services/win_system.dart';

void main() {
  group('LauncherController', () {
    test('omarchy flavor is switchable by default, others are locked', () {
      expect(
        LauncherController(initial: LauncherMode.omarchy).switchable,
        isTrue,
      );
      expect(
        LauncherController(initial: LauncherMode.win11).switchable,
        isFalse,
      );
      expect(
        LauncherController(initial: LauncherMode.macos).switchable,
        isFalse,
      );
    });

    test('select switches mode and notifies listeners', () {
      final controller = LauncherController();
      var notified = 0;
      controller.addListener(() => notified++);

      controller.select(LauncherMode.macos);
      expect(controller.mode, LauncherMode.macos);
      controller.select(LauncherMode.win11);
      expect(controller.mode, LauncherMode.win11);
      expect(notified, 2);
    });

    test('selecting the current mode does not notify', () {
      final controller = LauncherController();
      var notified = 0;
      controller.addListener(() => notified++);
      controller.select(LauncherMode.omarchy);
      expect(notified, 0);
    });

    test('a locked controller ignores select', () {
      final controller = LauncherController(initial: LauncherMode.win11);
      controller.select(LauncherMode.macos);
      expect(controller.mode, LauncherMode.win11);
    });

    test('switching closes overlays in every variant', () {
      final omarchy = OmarchyState();
      final win = WinSystemState();
      final mac = MacSystemState();
      omarchy.toggleCommandRunner();
      win.toggleStartMenu();
      mac.toggleLaunchpad();
      expect(omarchy.isCommandRunnerOpen, isTrue);
      expect(win.isStartMenuOpen, isTrue);
      expect(mac.isLaunchpadOpen, isTrue);

      LauncherController().select(LauncherMode.macos);

      expect(omarchy.isCommandRunnerOpen, isFalse);
      expect(win.isStartMenuOpen, isFalse);
      expect(mac.isLaunchpadOpen, isFalse);
    });
  });
}
