plugins {
    id("com.android.application")
    // Required for Firebase
    id("com.google.gms.google-services")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // IMPORTANT: Must match the package_name from google-services.json
    namespace = "com.example.cw6" 
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"  // for firebase plugins

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        // This must exactly match the "package_name" in google-services.json
        applicationId = "com.example.cw6"

        // minSdk 23 is required for recent firebase_auth versions
        minSdkVersion(23)

        // Use your Flutter config for the target/versions
        targetSdkVersion(flutter.targetSdkVersion)
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // For easy testing, you can use the debug signing config, or add your own.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
