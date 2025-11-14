// Test Account 1

// Email & Username : picadot171@hadvar.com / johndoe
// Password : Test@1234
// Mobile Number : 9979996653

// Test Account 2 
// Username : account123 
// Password : Admin@123


// dart fix --apply
// Privacy Policy : https://sites.google.com/view/polzet-privacypolicy/home
// 2 min OTP Valid

// Add Languages text  :  flutter gen-l10n


// BIOMETRIC AUTHENTICATION

// <uses-permission android:name="android.permission.USE_BIOMETRIC" />
// <uses-permission android:name="android.permission.USE_FINGERPRINT" android:maxSdkVersion="27" />



// --- MAINACTIVITY.KT ---- //


// package com.xtenal.polzet_mobile_app
// import android.content.Intent
// import android.os.Bundle
// import android.util.Log
// import io.flutter.embedding.android.FlutterFragmentActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel

// class MainActivity : FlutterFragmentActivity() {
//     private val CHANNEL = "intent_security"
//     private val TAG = "MainActivity"

//     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)
//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//             if (call.method == "verifyTrustedIntent") {
//                 result.success(true)
//             } else {
//                 result.notImplemented()
//             }
//         }
//     }

//     override fun onCreate(savedInstanceState: Bundle?) {
//         super.onCreate(savedInstanceState)
        
//         // Secure intent handling - prevent intent redirection vulnerabilities
//         validateIncomingIntent()
//     }

//     override fun onNewIntent(intent: Intent) {
//         super.onNewIntent(intent)
        
//         // Also validate any new intents received while activity is running
//         setIntent(intent)
//         validateIncomingIntent()
//     }

//     /**
//      * Validates incoming intent to prevent intent redirection attacks
//      */
//     private fun validateIncomingIntent() {
//         val receivedIntent = intent ?: return
        
//         // Check for nested intents that could be used for redirection attacks
//         val extras = receivedIntent.extras ?: return
        
//         for (key in extras.keySet()) {
//             val value = extras.get(key)
            
//             // If there's a nested Intent in the extras, validate it
//             if (value is Intent) {
//                 Log.w(TAG, "Nested Intent detected in extras with key: $key")
                
//                 // Remove dangerous URI permission flags
//                 sanitizeIntent(value)
                
//                 // DO NOT redirect nested intents - this is the vulnerability
//                 // Just log and ignore
//                 Log.w(TAG, "Nested Intent sanitized but not redirected")
//             }
//         }
//     }

//     /**
//      * Removes dangerous flags from an intent
//      */
//     private fun sanitizeIntent(intent: Intent) {
//         // Remove all URI permission grant flags
//         intent.removeFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
//         intent.removeFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
//         intent.removeFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
//         intent.removeFlags(Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)
//     }

//     /**
//      * Override to prevent accidental intent redirection via startActivity
//      */
//     override fun startActivity(intent: Intent?) {
//         if (intent != null && !isIntentSafe(intent)) {
//             Log.w(TAG, "Potentially unsafe intent blocked")
//             return
//         }
//         super.startActivity(intent)
//     }

//     /**
//      * Validates that an intent is safe to use
//      */
//     private fun isIntentSafe(intent: Intent): Boolean {
//         // Check if intent has URI permission flags
//         val flags = intent.flags
//         val hasUriPermissions = (flags and Intent.FLAG_GRANT_READ_URI_PERMISSION) != 0 ||
//                                (flags and Intent.FLAG_GRANT_WRITE_URI_PERMISSION) != 0 ||
//                                (flags and Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION) != 0 ||
//                                (flags and Intent.FLAG_GRANT_PREFIX_URI_PERMISSION) != 0
        
//         if (hasUriPermissions) {
//             Log.w(TAG, "Intent has URI permission flags")
//             return false
//         }
        
//         // Check if intent targets internal components
//         val component = intent.component
//         if (component != null && component.packageName != packageName) {
//             // External component - additional checks needed
//             val resolvedComponent = intent.resolveActivity(packageManager)
//             if (resolvedComponent == null) {
//                 Log.w(TAG, "Cannot resolve intent component")
//                 return false
//             }
//         }
        
//         return true
//     }
// }