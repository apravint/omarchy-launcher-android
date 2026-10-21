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

## 🛠️ Tech Stack & Dependencies

- **Framework**: Flutter 3.47.7 (Dart 3.13.5)
- **Design System**: Impeccable Design System with Cyberpunk Cyan, macOS Glass, and Windows Fluent Mica themes
- **Typography**: Google Fonts (`Outfit` & `JetBrains Mono`)
- **Formatting**: `intl: ^0.20.0`
- **Testing**: 100% pass rate on widget smoke test suite

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.27+
- Android Studio / Android SDK 34+

### Clone & Run
```bash
git clone https://github.com/apravint/omarchy-launcher-android.git
cd omarchy-launcher-android

# Fetch dependencies
flutter pub get

# Run tests
flutter test

# Run on connected Android device or desktop
flutter run

# Build release APK
flutter build apk --release

# Build for Web
flutter build web --release --base-href "/omarchy-launcher-android/"
```

---

## 📄 License

Licensed under the [MIT License](LICENSE).
Created with ❤️ by **Ayyappa Pravin** ([@apravint](https://github.com/apravint)).
