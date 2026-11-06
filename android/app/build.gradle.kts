plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.apravint.omarchy_launcher"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // One flavor per OS-style variant. The applicationId of each flavor matches the
    // standalone app it replaces, so existing installs upgrade in place.
    // The flavor name is also what Dart sees via `appFlavor` (lib/core/launcher_mode.dart).
    flavorDimensions += "variant"
    productFlavors {
        create("omarchy") {
            dimension = "variant"
            applicationId = "com.apravint.omarchy_launcher"
            resValue("string", "app_name", "Omarchy Multi-OS")
        }
        create("win11") {
            dimension = "variant"
            applicationId = "com.apravint.windows_11_launcher"
            resValue("string", "app_name", "Windows 11")
        }
        create("macos") {
            dimension = "variant"
            applicationId = "com.apravint.macos_sonoma_launcher"
            resValue("string", "app_name", "macOS Sonoma")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
