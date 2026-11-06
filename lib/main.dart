import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/launcher_controller.dart';
import 'core/launcher_mode.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  // `flutter run --flavor win11` etc. sets appFlavor; no flavor means Multi-OS.
  LauncherController.instance = LauncherController(
    initial: LauncherMode.fromFlavor(appFlavor),
  );
  runApp(const LauncherApp());
}
