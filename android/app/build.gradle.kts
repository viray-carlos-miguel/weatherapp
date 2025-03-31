plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Ensure Flutter Gradle plugin is applied last
}

android {
    namespace = "com.example.weatherapp"
    compileSdk = 34
    ndkVersion = "25.1.8937393"

    signingConfigs {
        create("release") {
            storeFile = file("../upload-keystore.jks")
            storePassword = project.findProperty("storePassword") as String? ?: ""
            keyAlias = project.findProperty("keyAlias") as String? ?: ""
            keyPassword = project.findProperty("keyPassword") as String? ?: ""
        }
    }

    defaultConfig {
        applicationId = "com.example.weatherapp"
        minSdk = 21
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
            isShrinkResources = false  // Ensure no shrinking errors
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
