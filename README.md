# 📱 Omarchy Multi-OS Android Launcher (`v2.0.0`)

[![GitHub Release](https://img.shields.io/github/v/release/apravint/omarchy-launcher-android?color=cyan&label=Latest%20Release)](https://github.com/apravint/omarchy-launcher-android/releases/tag/v2.0.0)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Android Min SDK](https://img.shields.io/badge/Android-7.0%2B%20(API%2024)-brightgreen)](https://developer.android.com)

**Omarchy Multi-OS Launcher** is a top-grade, high-performance home screen replacement for Android smartphones and tablets. It combines three iconic desktop operating system experiences into one fluid, glassmorphic Android launcher interface.

Developed by **Ayyappa Pravin** (<apravint@gmail.com>).

---

## ⚡ Key Features

- 🪟 **Windows 11 Mode**: Centered Taskbar, Windows 11 Start Menu with pinned app grid, search bar, and power options (`Power Off`, `Restart`).
-  **macOS Sonoma Mode**: Top macOS Menu Bar displaying Apple logo (``), status clock, battery telemetry, and a floating glassmorphic bottom Dock.
- ⚡ **Omarchy Cyberpunk Mode**: Ultra-sleek glassmorphic cyberpunk theme with dynamic glow effects.
- 📱 **Native App Drawer Engine**: Queries system `PackageManager` to retrieve all installed Android apps with search and category filtering.
- 📳 **Haptic Feedback Bridge**: Tactile vibration feedback on touch interactions.
- 🛡️ **4-Byte ZipAligned & V1/V2/V3 Signed**: Fully optimized for Motorola Edge, Google Pixel, Samsung Galaxy, Xiaomi, and Android 14/15 devices.

---

## 📦 Direct Download & Installation

1. Download the latest compiled APK: 📦 [OmarchyLauncher.apk](https://github.com/apravint/omarchy-launcher-android/releases/download/v2.0.0/OmarchyLauncher.apk)
2. Open the downloaded file on your Android device.
3. Allow **"Install from unknown sources"** if prompted.
4. Set **Omarchy Launcher** as your default home app!

---

## 🛠️ Architecture & Build Instructions

Built with Android Java, native WebView bridge, and GitHub Actions automated CI/CD.

```bash
# Clone the repository
git clone https://github.com/apravint/omarchy-launcher-android.git
cd omarchy-launcher-android

# Build using AAPT and D8 toolchain
$ANDROID_HOME/build-tools/34.0.0/aapt package -f -m \
  -J build/gen \
  -M android/app/src/main/AndroidManifest.xml \
  -S android/app/src/main/res \
  -I $ANDROID_HOME/platforms/android-34/android.jar
```

---

## 📄 License
Licensed under the [MIT License](LICENSE).
