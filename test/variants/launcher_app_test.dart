import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omarchy_launcher/app.dart';
import 'package:omarchy_launcher/core/launcher_controller.dart';
import 'package:omarchy_launcher/core/launcher_mode.dart';
import 'package:omarchy_launcher/variants/macos/services/mac_system.dart';
import 'package:omarchy_launcher/variants/omarchy/omarchy_state.dart';
import 'package:omarchy_launcher/variants/win11/services/win_system.dart';

void main() {
  void useDesktopViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
  }

  tearDown(() {
    OmarchyState().closeOverlays();
    WinSystemState().closeOverlays();
    MacSystemState().closeOverlays();
  });

  group('LauncherApp helpers', () {
    test('titleFor uses the Multi-OS title only when switchable', () {
      expect(
        LauncherApp.titleFor(LauncherMode.omarchy, switchable: true),
        'Omarchy Multi-OS Launcher',
      );
      expect(
        LauncherApp.titleFor(LauncherMode.win11, switchable: false),
        'Windows 11 Launcher',
      );
      expect(
        LauncherApp.titleFor(LauncherMode.macos, switchable: false),
        'macOS Sonoma Launcher',
      );
    });

    // testWidgets: google_fonts text themes need the widget test binding.
    testWidgets('themeFor returns a dark theme for omarchy', (tester) async {
      expect(
        LauncherApp.themeFor(LauncherMode.omarchy).brightness,
        Brightness.dark,
      );
    });

    testWidgets('themeFor follows the dark-mode toggle of win11 and macos', (
      tester,
    ) async {
      final win = WinSystemState();
      final before = win.isDarkMode;
      expect(
        LauncherApp.themeFor(LauncherMode.win11).brightness,
        before ? Brightness.dark : Brightness.light,
      );
      win.toggleDarkMode();
      expect(
        LauncherApp.themeFor(LauncherMode.win11).brightness,
        before ? Brightness.light : Brightness.dark,
      );
      win.toggleDarkMode();

      final mac = MacSystemState();
      final macBefore = mac.isDarkMode;
      expect(
        LauncherApp.themeFor(LauncherMode.macos).brightness,
        macBefore ? Brightness.dark : Brightness.light,
      );
    });
  });

  testWidgets(
    'Multi-OS build: switcher pill moves between all three desktops',
    (tester) async {
      useDesktopViewport(tester);
      final controller = LauncherController();
      await tester.pumpWidget(LauncherApp(controller: controller));
      await tester.pumpAndSettle();

      // Pill shows all three modes; Omarchy desktop is up first.
      expect(find.text('Omarchy Hyprland'), findsOneWidget);
      expect(find.text('macOS Sonoma'), findsOneWidget);
      expect(find.text('Windows 11'), findsOneWidget);
      expect(find.text('kitty : ~ / sovereign-workstation'), findsOneWidget);

      await tester.tap(find.text('macOS Sonoma'));
      await tester.pumpAndSettle();
      expect(controller.mode, LauncherMode.macos);
      expect(find.text('Macintosh HD'), findsAtLeastNWidgets(1));
      expect(find.text('kitty : ~ / sovereign-workstation'), findsNothing);

      await tester.tap(find.text('Windows 11'));
      await tester.pumpAndSettle();
      expect(controller.mode, LauncherMode.win11);
      expect(find.text('Recycle Bin'), findsOneWidget);

      await tester.tap(find.text('Omarchy Hyprland'));
      await tester.pumpAndSettle();
      expect(controller.mode, LauncherMode.omarchy);
    },
  );

  testWidgets('Omarchy desktop opens the Wofi runner', (tester) async {
    useDesktopViewport(tester);
    await tester.pumpWidget(LauncherApp(controller: LauncherController()));
    await tester.pumpAndSettle();

    expect(find.text('IRAM OS Hyprland'), findsNothing);
    OmarchyState().toggleCommandRunner();
    await tester.pumpAndSettle();
    expect(find.text('IRAM OS Hyprland'), findsOneWidget);
  });

  testWidgets(
    'win11 flavor: Windows desktop only, no switcher, start menu and action center',
    (tester) async {
      useDesktopViewport(tester);
      await tester.pumpWidget(
        LauncherApp(
          controller: LauncherController(initial: LauncherMode.win11),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Omarchy Hyprland'), findsNothing);
      expect(find.text('Recycle Bin'), findsOneWidget);
      expect(find.text('This PC'), findsAtLeastNWidgets(1));
      expect(
        find.text('Local Disk (C:) Free Space: 742 GB of 1 TB'),
        findsOneWidget,
      );

      final system = WinSystemState();
      system.toggleStartMenu();
      await tester.pumpAndSettle();
      expect(find.text('Pinned'), findsOneWidget);
      expect(find.text('Recommended'), findsOneWidget);
      system.closeOverlays();
      await tester.pumpAndSettle();
      expect(find.text('Pinned'), findsNothing);

      system.toggleActionCenter();
      await tester.pumpAndSettle();
      expect(find.text('Wi-Fi'), findsOneWidget);
      expect(find.text('Night light'), findsOneWidget);
    },
  );

  testWidgets(
    'macos flavor: Sonoma desktop only, no switcher, control center and About dialog',
    (tester) async {
      useDesktopViewport(tester);
      await tester.pumpWidget(
        LauncherApp(
          controller: LauncherController(initial: LauncherMode.macos),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Omarchy Hyprland'), findsNothing);
      expect(find.text('Finder'), findsAtLeastNWidgets(1));
      expect(find.text('Macintosh HD'), findsAtLeastNWidgets(1));
      expect(find.text('Cupertino'), findsOneWidget);

      final system = MacSystemState();
      system.toggleControlCenter();
      await tester.pumpAndSettle();
      expect(find.text('AirDrop'), findsOneWidget);
      system.closeOverlays();
      await tester.pumpAndSettle();
      expect(find.text('AirDrop'), findsNothing);

      system.toggleAboutMac();
      await tester.pumpAndSettle();
      expect(find.text('About This Mac'), findsOneWidget);
      system.toggleAboutMac();
      await tester.pumpAndSettle();
      expect(find.text('About This Mac'), findsNothing);
    },
  );
}
