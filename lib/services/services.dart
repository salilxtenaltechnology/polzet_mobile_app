// lib/services/secure_url_handler.dart

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

/// Secure URL handler that prevents Intent Redirection vulnerabilities
///
/// This service validates all URLs before launching them to prevent:
/// - Intent Redirection attacks
/// - Phishing attempts
/// - Malicious URL schemes
class SecureUrlHandler {
  // ✅ SECURITY: Define your allowed domains (whitelist approach)
  static const List<String> _allowedDomains = [
    'polzet.com',
    'www.polzet.com',
    'api.polzet.com',
    // Add your trusted domains here
  ];

  // ✅ SECURITY: Define allowed URL schemes
  static const List<String> _allowedSchemes = [
    'https',
    'http',
    'mailto',
    'tel',
    'sms',
  ];

  /// Launch a URL with security validation
  ///
  /// Returns true if successfully launched, false otherwise
  static Future<bool> launchSecureUrl(
    String urlString, {
    bool requireWhitelist = false,
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    try {
      // Validate URL format
      final uri = Uri.tryParse(urlString);
      if (uri == null) {
        debugPrint('❌ Invalid URL format: $urlString');
        return false;
      }

      // Check if scheme is allowed
      if (!_allowedSchemes.contains(uri.scheme.toLowerCase())) {
        debugPrint('❌ Blocked unsafe scheme: ${uri.scheme}');
        return false;
      }

      // If whitelist is required, check domain
      if (requireWhitelist && uri.host.isNotEmpty) {
        if (!_isDomainAllowed(uri.host)) {
          debugPrint('❌ Blocked non-whitelisted domain: ${uri.host}');
          return false;
        }
      }

      // Additional security checks
      if (!_isUrlSafe(uri)) {
        debugPrint('❌ URL failed security checks: $urlString');
        return false;
      }

      // ✅ URL is safe, proceed with launch
      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) {
        debugPrint('❌ Cannot launch URL: $urlString');
        return false;
      }

      return await launchUrl(
        uri,
        mode: mode,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: false, // Disable JS in WebView for security
          enableDomStorage: false,
        ),
      );
    } catch (e) {
      debugPrint('❌ Error launching URL: $e');
      return false;
    }
  }

  /// Check if domain is in whitelist
  static bool _isDomainAllowed(String host) {
    final lowerHost = host.toLowerCase();

    // Check exact match or subdomain match
    for (final domain in _allowedDomains) {
      if (lowerHost == domain || lowerHost.endsWith('.$domain')) {
        return true;
      }
    }
    return false;
  }

  /// Additional security checks for URLs
  static bool _isUrlSafe(Uri uri) {
    // Block file:// and other dangerous schemes
    if (uri.scheme == 'file' ||
        uri.scheme == 'javascript' ||
        uri.scheme == 'data') {
      return false;
    }

    // Block URLs with @ (potential phishing: https://evil.com@good.com)
    if (uri.toString().contains('@')) {
      return false;
    }

    // Block URLs with suspicious patterns
    final suspiciousPatterns = [
      'javascript:',
      'data:text/html',
      '<script',
      'onerror=',
    ];

    final urlLower = uri.toString().toLowerCase();
    for (final pattern in suspiciousPatterns) {
      if (urlLower.contains(pattern)) {
        return false;
      }
    }

    return true;
  }

  /// Launch email with validation
  static Future<bool> launchEmail(String email,
      {String? subject, String? body}) async {
    if (!_isValidEmail(email)) {
      debugPrint('❌ Invalid email: $email');
      return false;
    }

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );

    return await launchSecureUrl(uri.toString());
  }

  /// Launch phone number with validation
  static Future<bool> launchPhone(String phoneNumber) async {
    // Remove common formatting characters
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleanNumber.isEmpty || cleanNumber.length < 10) {
      debugPrint('❌ Invalid phone number: $phoneNumber');
      return false;
    }

    final uri = Uri(scheme: 'tel', path: cleanNumber);
    return await launchSecureUrl(uri.toString());
  }

  /// Launch SMS with validation
  static Future<bool> launchSMS(String phoneNumber, {String? message}) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleanNumber.isEmpty) {
      debugPrint('❌ Invalid phone number for SMS: $phoneNumber');
      return false;
    }

    final uri = Uri(
      scheme: 'sms',
      path: cleanNumber,
      queryParameters: message != null ? {'body': message} : null,
    );

    return await launchSecureUrl(uri.toString());
  }

  /// Validate email format
  static bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Show confirmation dialog before launching external URL
  static Future<bool> launchWithConfirmation(
    BuildContext context,
    String urlString,
  ) async {
    final shouldLaunch = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open External Link'),
        content: Text('Do you want to open this link?\n\n$urlString'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Open'),
          ),
        ],
      ),
    );

    if (shouldLaunch == true) {
      return await launchSecureUrl(urlString);
    }
    return false;
  }
}

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

/*

// Example 1: Launch a whitelisted URL
await SecureUrlHandler.launchSecureUrl(
  'https://polzet.com/terms',
  requireWhitelist: true,
);

// Example 2: Launch external URL (any HTTPS)
await SecureUrlHandler.launchSecureUrl(
  'https://google.com',
  requireWhitelist: false,
);

// Example 3: Launch with user confirmation
await SecureUrlHandler.launchWithConfirmation(
  context,
  'https://example.com',
);

// Example 4: Launch email
await SecureUrlHandler.launchEmail(
  'support@polzet.com',
  subject: 'App Feedback',
  body: 'Hi team...',
);

// Example 5: Launch phone
await SecureUrlHandler.launchPhone('+1-555-0123');

// Example 6: Launch SMS
await SecureUrlHandler.launchSMS(
  '+1-555-0123',
  message: 'Hello from Polzet!',
);

// Example 7: In a button
ElevatedButton(
  onPressed: () async {
    final success = await SecureUrlHandler.launchSecureUrl(
      'https://polzet.com/help',
    );
    
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  },
  child: const Text('Open Help'),
);

*/
