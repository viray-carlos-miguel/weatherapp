plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Ensure Flutter Gradle plugin is applied last
}

android {
    namespace = "com.example.weatherapp"
    compileSdk = 34  // Update as needed
    ndkVersion = "25.1.8937393"  // Replace with actual NDK version

    signingConfigs {
        create("release") {
            storeFile = file("../upload-keystore.jks")  // Correct path to keystore
            storePassword = project.findProperty("storePassword") as String? ?: ""
            keyAlias = project.findProperty("keyAlias") as String? ?: ""
            keyPassword = project.findProperty("keyPassword") as String? ?: ""
        }
    }

    defaultConfig {
        applicationId = "com.example.weatherapp"
        minSdk = 21  // Replace with actual minSdkVersion
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("release")  // Correct release signing
        }
    }
}

flutter {
    source = "../.."
}
