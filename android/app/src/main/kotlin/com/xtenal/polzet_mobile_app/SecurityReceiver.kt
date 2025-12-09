package com.xtenal.polzet_mobile_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class SecurityReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {

        // ❌ Reject if Intent is null
        if (intent == null || context == null) return

        // ❌ Reject if Intent comes from another package
        // Use intent.component?.packageName to get the package name
        val sourcePackage = intent.component?.packageName
        if (sourcePackage == null) return
        if (sourcePackage != context.packageName) return

        // If it reaches here, Intent is safe
        // No action required
    }
}