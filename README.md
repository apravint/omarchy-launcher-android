# 📱 Omarchy Multi-OS Launcher for Android

[![Flutter CI/CD](https://github.com/apravint/omarchy-launcher-android/actions/workflows/build-and-release.yml/badge.svg)](https://github.com/apravint/omarchy-launcher-android/actions/workflows/build-and-release.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.47%20%7C%20Dart%203.13-02569B?logo=flutter)](https://flutter.dev)
[![Live Web Demo](https://img.shields.io/badge/Live%20Demo-GitHub%20Pages-brightgreen?logo=googlechrome)](https://apravint.github.io/omarchy-launcher-android/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Android Min SDK](https://img.shields.io/badge/Android-7.0%2B%20(API%2024)-3DDC84?logo=android)](https://developer.android.com)

A **pure Flutter 3.x** unified desktop simulation launcher that brings **three iconic operating systems into one unified interface** for Android smartphones, tablets, foldables, and browsers. Switch dynamically with 1 tap between **Omarchy Hyprland / IRAM OS**, **macOS Sonoma**, and **Windows 11 Fluent Mica**.

---

## 🌐 Live Interactive Web Demo

Experience the 3-in-1 launcher directly in your web browser:
👉 **[Launch Omarchy Multi-OS Web Preview](https://apravint.github.io/omarchy-launcher-android/)**

---

## ⚡ The 3 OS Experiences

### 1. 🌌 Omarchy Hyprland / IRAM OS Mode
- **Top Waybar**: Status bar with Arch/Omarchy logo, interactive workspace switchers `[1] [2] [3] [4] [5]`, active window title with green pulsing heartbeat indicator, and hardware telemetry (CPU, RAM, Battery, Digital Clock).
- **Dual Tiled Canvas**: Side-by-side tiling layout with an interactive Kitty terminal window running live neofetch specs and a Neovim syntax-highlighted editor tile.
- **Wofi Command Runner (`Super+D`)**: Fuzzy launcher popup filtering applications and bash commands instantly.

### 2.  macOS Sonoma Mode
- **Top Menu Bar**: Apple menu (``), active app title, File/Edit/View desktop menu bar, and status indicators.
- **Desktop Storage**: Macintosh HD, Projects, and Notes shortcuts with vibrant Sonoma background gradient.
- **Floating Glassmorphic Dock**: Magnifying icon dock at the bottom of the screen with quick app switcher.

### 3. 🪟 Windows 11 Fluent Mica Mode
- **Centered Taskbar**: Windows Start button `⊞`, search button, and pinned applications.
- **Fluent Start Menu**: Centered floating card with pinned applications grid and instant search.
- **Desktop Canvas**: Windows 11 Dark Bloom wallpaper with Recycle Bin and This PC icons.

### 4. 🎛️ Unified Mode Switcher Pill
- Seamless 1-tap pill floating at the top of the screen allowing instant switching between all 3 OS engines without restarting the application.

---

## 🧩 Flavors (one codebase, three launchers)

This repo is the single home for the OS-style launchers that used to live in separate, near-identical repositories. Each variant is an Android **product flavor**; the flavor name is read at runtime through Flutter's `appFlavor` and selects the variant (`lib/core/launcher_mode.dart`). Application ids are unchanged, so existing installs upgrade in place.

| Flavor | Application id | Launcher label | Behavior | Replaces repo(s) |
|---|---|---|---|---|
| `omarchy` | `com.apravint.omarchy_launcher` | Omarchy Multi-OS | Omarchy Hyprland desktop plus the 1-tap switcher pill to the other two styles | `omarchy-launcher-android` (this repo) |
| `win11` | `com.apravint.windows_11_launcher` | Windows 11 | Windows 11 Fluent desktop only (taskbar, Start menu, action center, File Explorer) | `omarchy-launcher-win11`, `windows-11-launcher-android` (identical copies) |
| `macos` | `com.apravint.macos_sonoma_launcher` | macOS Sonoma | macOS Sonoma desktop only (menu bar, dock, Launchpad, Control Center, About This Mac) | `omarchy-launcher-macos`, `macos-sonoma-launcher-android` (identical copies) |

Running without `--flavor` (web, desktop, `flutter test`) behaves like the `omarchy` flavor.

### Project layout

```
lib/
  main.dart                 entry point; maps appFlavor -> LauncherMode
  app.dart                  LauncherApp: picks theme + desktop for the active mode
  core/                     LauncherMode (flavor table), LauncherController (active mode, switching)
  shared/                   ModeSwitcherPill (only shown in the omarchy flavor)
  variants/
    omarchy/                Waybar, tiling desktop, Wofi runner, theme, state
    win11/                  models, services, theme, screens, widgets
    macos/                  models, services, theme, screens, widgets
test/                       unit tests (mode/flavor mapping, controller, per-variant state) and widget tests
```

Each variant keeps its own state class (`OmarchyState`, `WinSystemState`, `MacSystemState`), theme, and widgets; only the mode/flavor plumbing is shared.

---

## 🛠️ Tech Stack & Dependencies

- **Framework**: Flutter 3.47.7 (Dart 3.13.5)
- **Design System**: Cyberpunk Cyan (Omarchy), macOS Glass, and Windows Fluent Mica themes
- **Typography**: Google Fonts (`Outfit` & `JetBrains Mono`)
- **Formatting**: `intl: ^0.20.0`
- **Testing**: unit tests for flavor mapping, the mode controller, and each variant's state, plus widget tests for every flavor's desktop and the mode switcher

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.27+
- Android Studio / Android SDK 34+

### Clone & Run
```bash
git clone https://github.com/apravint/omarchy-launcher-android.git
cd omarchy-launcher-android

flutter pub get
flutter analyze
flutter test

# Run a flavor on a connected Android device
flutter run --flavor omarchy
flutter run --flavor win11
flutter run --flavor macos

# Build release APKs (one per flavor)
flutter build apk --release --flavor omarchy
flutter build apk --release --flavor win11
flutter build apk --release --flavor macos

# Web / desktop (no flavor, Omarchy Multi-OS behavior)
flutter run -d chrome
flutter build web --release --base-href "/omarchy-launcher-android/"
```

CI (`.github/workflows/build-and-release.yml`) runs analyze and tests, then builds all three flavor APKs.

---

## 📄 License

Licensed under the [MIT License](LICENSE).
Created with ❤️ by **Ayyappa Pravin** ([@apravint](https://github.com/apravint)).
