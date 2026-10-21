import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/multi_os_screen.dart';
import 'theme/omarchy_theme.dart';

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
  runApp(const OmarchyLauncherApp());
}

class OmarchyLauncherApp extends StatelessWidget {
  const OmarchyLauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omarchy Multi-OS Launcher',
      debugShowCheckedModeBanner: false,
      theme: OmarchyTheme.theme(),
      home: const MultiOsScreen(),
    );
  }
}
