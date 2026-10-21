import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omarchy_launcher/main.dart';
import 'package:omarchy_launcher/models/launcher_mode.dart';
import 'package:omarchy_launcher/services/launcher_system.dart';

void main() {
  testWidgets('Omarchy Multi-OS Launcher smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const OmarchyLauncherApp());
    await tester.pumpAndSettle();

    // Verify mode switcher options
    expect(find.text('Omarchy Hyprland'), findsOneWidget);
    expect(find.text('macOS Sonoma'), findsOneWidget);
    expect(find.text('Windows 11'), findsOneWidget);

    // Verify initial Omarchy Hyprland desktop elements
    expect(find.text('Wofi'), findsOneWidget);
    expect(find.text('kitty : ~ / sovereign-workstation'), findsOneWidget);

    final state = LauncherSystemState();

    // Switch to macOS mode
    state.setMode(LauncherMode.macos);
    await tester.pumpAndSettle();
    expect(find.text(''), findsOneWidget);
    expect(find.text('Macintosh HD'), findsOneWidget);

    // Switch to Windows 11 mode
    state.setMode(LauncherMode.win11);
    await tester.pumpAndSettle();
    expect(find.text('Recycle Bin'), findsOneWidget);
    expect(find.text('This PC'), findsOneWidget);

    // Switch back to Omarchy mode and test Wofi runner
    state.setMode(LauncherMode.omarchy);
    await tester.pumpAndSettle();
    state.toggleCommandRunner();
    await tester.pumpAndSettle();
    expect(find.text('IRAM OS Hyprland'), findsOneWidget);
  });
}
