# ================================
# POLZET APP - PROGUARD RULES
# Intent Redirection Prevention
# ================================

# ✅ Flutter Framework Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# ✅ Keep MainActivity but obfuscate internals
-keep public class com.xtenal.polzet_mobile_app.MainActivity {
    public <methods>;
}