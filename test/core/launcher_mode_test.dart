import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:omarchy_launcher/core/launcher_mode.dart';

void main() {
  group('LauncherMode.fromFlavor', () {
    test('maps each flavor name to its mode', () {
      expect(LauncherMode.fromFlavor('omarchy'), LauncherMode.omarchy);
      expect(LauncherMode.fromFlavor('win11'), LauncherMode.win11);
      expect(LauncherMode.fromFlavor('macos'), LauncherMode.macos);
    });

    test('falls back to omarchy for null or unknown flavors', () {
      expect(LauncherMode.fromFlavor(null), LauncherMode.omarchy);
      expect(LauncherMode.fromFlavor(''), LauncherMode.omarchy);
      expect(LauncherMode.fromFlavor('linux'), LauncherMode.omarchy);
    });
  });

  test('flavor names and labels are unique', () {
    expect(
      LauncherMode.values.map((m) => m.flavor).toSet().length,
      LauncherMode.values.length,
    );
    expect(
      LauncherMode.values.map((m) => m.label).toSet().length,
      LauncherMode.values.length,
    );
  });

  test('every mode has a matching Android product flavor', () {
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();
    for (final mode in LauncherMode.values) {
      expect(
        gradle,
        contains('create("${mode.flavor}")'),
        reason: 'missing flavor for ${mode.flavor}',
      );
    }
  });

  test('flavor application ids keep the ids of the legacy single-OS apps', () {
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();
    expect(gradle, contains('applicationId = "com.apravint.omarchy_launcher"'));
    expect(
      gradle,
      contains('applicationId = "com.apravint.windows_11_launcher"'),
    );
    expect(
      gradle,
      contains('applicationId = "com.apravint.macos_sonoma_launcher"'),
    );
  });
}
