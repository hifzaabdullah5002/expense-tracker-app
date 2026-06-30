plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // Aapka asli package name yahan set kar diya hai
    namespace = "com.example.hifza_expense_tracker"
    compileSdk = flutter.compileSdkVersion

    // Error fix karne ke liye exact NDK version
    ndkVersion = "27.0.12077973"

    // Java version ko 17 par rakha hai
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // Kotlin target ko bhi Java 17 par fix rakha hai
    kotlin {
        jvmToolchain(17)
    }

    defaultConfig {
        // Aapka asli package name yahan bhi set kar diya hai
        applicationId = "com.example.hifza_expense_tracker"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
}

flutter {
    source = "../.."
}
