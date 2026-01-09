# proguard-rules.pro
# Minimal / example ProGuard/R8 rules for SafeCleaner Pro.
# Customize these rules to the plugins your app uses. Keep any classes
# that use reflection, Kotlin metadata, content providers, and Flutter
# embedding classes.

# Keep Flutter embedding, engine and plugin registrant classes
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.engine.plugins.** { *; }

# Keep Shizuku API/provider
-keep class dev.rikka.shizuku.** { *; }
-keep class rikka.shizuku.** { *; }
-keep class com.rikka.shizuku.** { *; }
-keep class moe.shizuku.** { *; }

# Keep the app's MainActivity and any classes used by MethodChannel/native calls
-keep class com.safecleaner.pro.MainActivity { *; }
-keep class com.safecleaner.pro.** { *; }

# Keep Flutter MethodChannel and plugin entrypoints
-keep class io.flutter.embedding.** { *; }
-keepclassmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

# Ensure provider classes declared in AndroidManifest are kept
-keep public class * extends android.content.ContentProvider { *; }

# device_info_plus (package as seen in plugin sources)
-keep class dev.fluttercommunity.plus.device_info.** { *; }

# SharedPreferences / common Android plugin classes
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Keep path_provider implementation classes
-keep class com.example.pathprovider?** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }
-keep class com.**pathprovider** { *; }

# Keep permission_handler plugin classes (Android implementation)
-keep class com.baseflow.permissionhandler.** { *; }
-keep class com.permission_handler.** { *; }

# Keep classes that implement FlutterPlugin / ActivityAware (entrypoints for plugins)
-keep class * implements io.flutter.embedding.engine.plugins.FlutterPlugin { *; }
-keep class * implements io.flutter.embedding.engine.plugins.activity.ActivityAware { *; }

# Keep Parcelable creators and classes used by Android framework
-keepclassmembers class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator CREATOR;
}

# Keep Kotlin metadata and standard library classes used via reflection
-keepclassmembers class kotlin.Metadata { *; }
-keep class kotlin.** { *; }
-dontwarn kotlin.**

# Keep classes annotated with @Keep (AndroidX)
-keep @androidx.annotation.Keep class * { *; }
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# Keep classes referenced from native code or by name
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod,SourceFile,LineNumberTable

# Keep reflection-targeted model classes used by JSON libraries (GSON/Moshi) - add your own packages if needed
-keep class com.google.gson.** { *; }
-keep class com.squareup.moshi.** { *; }
-dontwarn com.google.gson.**
-dontwarn com.squareup.moshi.**

# Suppress warnings for Play Core and other optional libs
-dontwarn com.google.android.play.core.**
-dontwarn com.android.installreferrer.**

# Keep mapping for JNI/native methods: methods called from native must be kept by name
-keepclasseswithmembernames class * {
    native <methods>;
}
