// lib/services/pin_service.dart
// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class PinService {
  // SharedPreferences keys
  static const String _pinKey = 'user_security_pin';
  static const String _pinHashKey = 'user_pin_hash';
  static const String _pinSaltKey = 'user_pin_salt';
  static const String _pinEnabledKey = 'pin_security_enabled';
  static const String _pinAttemptsKey = 'pin_attempts_count';
  static const String _pinLockTimeKey = 'pin_lock_time';
  static const String _lastPinChangeKey = 'last_pin_change_time';

  // PIN configuration
  static const int maxPinAttempts = 5;
  static const int lockoutDurationMinutes = 15;
  static const int pinLength = 4;

  // ===== PIN MANAGEMENT METHODS =====

  /// Save PIN to local storage with proper encryption
  static Future<bool> savePin(String pin) async {
    try {
      if (!_isValidPin(pin)) {
        throw Exception('Invalid PIN format');
      }

      final prefs = await SharedPreferences.getInstance();
      
      // Generate salt for this PIN
      final salt = _generateSalt();
      
      // Hash the PIN with salt
      final hashedPin = _hashPin(pin, salt);
      
      // Save hashed PIN and salt
      await prefs.setString(_pinHashKey, hashedPin);
      await prefs.setString(_pinSaltKey, salt);
      await prefs.setInt(_lastPinChangeKey, DateTime.now().millisecondsSinceEpoch);
      
      // Reset attempts counter
      await _resetPinAttempts();
      
      return true;
    } catch (e) {
      print('Error saving PIN: $e');
      return false;
    }
  }

  /// Change existing PIN (requires verification of old PIN)
  static Future<bool> changePin(String oldPin, String newPin) async {
    try {
      // Verify old PIN first
      final isOldPinCorrect = await verifyPin(oldPin);
      if (!isOldPinCorrect) {
        return false;
      }
      
      // Save new PIN
      return await savePin(newPin);
    } catch (e) {
      print('Error changing PIN: $e');
      return false;
    }
  }

  /// Clear saved PIN from local storage
  static Future<void> clearSavedPin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinHashKey);
    await prefs.remove(_pinSaltKey);
    await prefs.remove(_pinEnabledKey);
    await prefs.remove(_pinAttemptsKey);
    await prefs.remove(_pinLockTimeKey);
    await prefs.remove(_lastPinChangeKey);
  }

  /// Check if PIN is set in local storage
  static Future<bool> isPinSet() async {
    final prefs = await SharedPreferences.getInstance();
    final pinHash = prefs.getString(_pinHashKey);
    final pinSalt = prefs.getString(_pinSaltKey);
    return pinHash != null && pinSalt != null;
  }

  /// Verify entered PIN against stored PIN
  static Future<bool> verifyPin(String enteredPin) async {
    try {
      // Check if PIN is locked due to too many attempts
      if (await _isPinLocked()) {
        throw Exception('PIN is locked due to too many failed attempts');
      }

      final prefs = await SharedPreferences.getInstance();
      final storedHash = prefs.getString(_pinHashKey);
      final storedSalt = prefs.getString(_pinSaltKey);
      
      if (storedHash == null || storedSalt == null) {
        return false;
      }
      
      // Hash entered PIN with stored salt
      final enteredPinHash = _hashPin(enteredPin, storedSalt);
      
      // Compare hashes
      final isCorrect = enteredPinHash == storedHash;
      
      if (isCorrect) {
        // Reset attempts on successful verification
        await _resetPinAttempts();
        return true;
      } else {
        // Increment failed attempts
        await _incrementPinAttempts();
        return false;
      }
    } catch (e) {
      print('Error verifying PIN: $e');
      return false;
    }
  }

  // ===== PIN SECURITY STATE METHODS =====

  /// Save PIN security enabled state
  static Future<void> setPinSecurityEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pinEnabledKey, enabled);
  }

  /// Check if PIN security is enabled
  static Future<bool> isPinSecurityEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_pinEnabledKey) ?? false;
  }

  // ===== PIN ATTEMPT MANAGEMENT =====

  /// Check if PIN is currently locked due to failed attempts
  static Future<bool> _isPinLocked() async {
    final prefs = await SharedPreferences.getInstance();
    final lockTime = prefs.getInt(_pinLockTimeKey);
    
    if (lockTime == null) return false;
    
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final lockDuration = lockoutDurationMinutes * 60 * 1000; // Convert to milliseconds
    
    return (currentTime - lockTime) < lockDuration;
  }

  /// Get remaining lockout time in minutes
  static Future<int> getRemainingLockoutMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    final lockTime = prefs.getInt(_pinLockTimeKey);
    
    if (lockTime == null) return 0;
    
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final lockDuration = lockoutDurationMinutes * 60 * 1000;
    final elapsed = currentTime - lockTime;
    
    if (elapsed >= lockDuration) return 0;
    
    final remainingMs = lockDuration - elapsed;
    return (remainingMs / (60 * 1000)).ceil();
  }

  /// Increment failed PIN attempts
  static Future<void> _incrementPinAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final currentAttempts = prefs.getInt(_pinAttemptsKey) ?? 0;
    final newAttempts = currentAttempts + 1;
    
    await prefs.setInt(_pinAttemptsKey, newAttempts);
    
    // Lock PIN if max attempts reached
    if (newAttempts >= maxPinAttempts) {
      await prefs.setInt(_pinLockTimeKey, DateTime.now().millisecondsSinceEpoch);
    }
  }

  /// Reset PIN attempts counter
  static Future<void> _resetPinAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinAttemptsKey);
    await prefs.remove(_pinLockTimeKey);
  }

  /// Get current PIN attempts count
  static Future<int> getPinAttemptsCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pinAttemptsKey) ?? 0;
  }

  /// Get remaining PIN attempts before lockout
  static Future<int> getRemainingAttempts() async {
    final currentAttempts = await getPinAttemptsCount();
    return maxPinAttempts - currentAttempts;
  }

  // ===== PIN VALIDATION AND UTILITY METHODS =====

  /// Validate PIN format
  static bool _isValidPin(String pin) {
    if (pin.length != pinLength) return false;
    if (!RegExp(r'^\d+$').hasMatch(pin)) return false; // Only digits
    if (pin == '0000' || pin == '1234' || pin == '1111') return false; // Common weak PINs
    return true;
  }

  /// Generate random salt for PIN hashing
  static String _generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  /// Hash PIN with salt using SHA-256
  static String _hashPin(String pin, String salt) {
    final pinBytes = utf8.encode(pin);
    final saltBytes = base64Decode(salt);
    final combined = [...pinBytes, ...saltBytes];
    final digest = sha256.convert(combined);
    return digest.toString();
  }

  /// Get PIN strength description
  static String getPinStrength(String pin) {
    if (pin.length < pinLength) return 'Too short';
    if (!RegExp(r'^\d+$').hasMatch(pin)) return 'Only numbers allowed';
    if (pin == '0000' || pin == '1234' || pin == '1111' || pin == '2222') return 'Too weak';
    
    // Check for sequential numbers
    bool isSequential = true;
    for (int i = 1; i < pin.length; i++) {
      if (int.parse(pin[i]) != int.parse(pin[i-1]) + 1) {
        isSequential = false;
        break;
      }
    }
    if (isSequential) return 'Avoid sequential numbers';
    
    // Check for repeated numbers
    bool isRepeated = pin.split('').toSet().length == 1;
    if (isRepeated) return 'Avoid repeated numbers';
    
    return 'Strong';
  }

  // ===== PIN AUTHENTICATION FLOW =====

  /// Complete PIN authentication with lockout handling
  static Future<PinAuthResult> authenticateWithPin(String enteredPin) async {
    try {
      // Check if PIN is locked
      if (await _isPinLocked()) {
        final remainingMinutes = await getRemainingLockoutMinutes();
        return PinAuthResult(
          success: false,
          message: 'PIN locked. Try again in $remainingMinutes minutes.',
          isLocked: true,
          remainingAttempts: 0,
        );
      }

      // Verify PIN
      final isCorrect = await verifyPin(enteredPin);
      
      if (isCorrect) {
        return PinAuthResult(
          success: true,
          message: 'PIN verified successfully',
          isLocked: false,
          remainingAttempts: maxPinAttempts,
        );
      } else {
        final remainingAttempts = await getRemainingAttempts();
        return PinAuthResult(
          success: false,
          message: 'Incorrect PIN. $remainingAttempts attempts remaining.',
          isLocked: false,
          remainingAttempts: remainingAttempts,
        );
      }
    } catch (e) {
      return PinAuthResult(
        success: false,
        message: 'Authentication error: $e',
        isLocked: false,
        remainingAttempts: 0,
      );
    }
  }

  // ===== PIN STATISTICS =====

  /// Get PIN last change date
  static Future<DateTime?> getLastPinChangeDate() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastPinChangeKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Check if PIN needs to be changed (optional - for security policies)
  static Future<bool> isPinExpired({int maxDays = 90}) async {
    final lastChange = await getLastPinChangeDate();
    if (lastChange == null) return false;
    
    final daysSinceChange = DateTime.now().difference(lastChange).inDays;
    return daysSinceChange > maxDays;
  }

  // ===== ADMIN/RESET METHODS =====

  /// Reset PIN lockout (admin function)
  static Future<void> resetPinLockout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinAttemptsKey);
    await prefs.remove(_pinLockTimeKey);
  }

  /// Get complete PIN status
  static Future<PinStatus> getPinStatus() async {
    return PinStatus(
      isPinSet: await isPinSet(),
      isPinEnabled: await isPinSecurityEnabled(),
      isLocked: await _isPinLocked(),
      attemptsCount: await getPinAttemptsCount(),
      remainingAttempts: await getRemainingAttempts(),
      remainingLockoutMinutes: await getRemainingLockoutMinutes(),
      lastChangeDate: await getLastPinChangeDate(),
      isExpired: await isPinExpired(),
    );
  }
}

// ===== DATA CLASSES =====

/// Result class for PIN authentication
class PinAuthResult {
  final bool success;
  final String message;
  final bool isLocked;
  final int remainingAttempts;

  PinAuthResult({
    required this.success,
    required this.message,
    required this.isLocked,
    required this.remainingAttempts,
  });
}

/// Status class for PIN information
class PinStatus {
  final bool isPinSet;
  final bool isPinEnabled;
  final bool isLocked;
  final int attemptsCount;
  final int remainingAttempts;
  final int remainingLockoutMinutes;
  final DateTime? lastChangeDate;
  final bool isExpired;

  PinStatus({
    required this.isPinSet,
    required this.isPinEnabled,
    required this.isLocked,
    required this.attemptsCount,
    required this.remainingAttempts,
    required this.remainingLockoutMinutes,
    required this.lastChangeDate,
    required this.isExpired,
  });

  @override
  String toString() {
    return 'PinStatus(isPinSet: $isPinSet, isPinEnabled: $isPinEnabled, '
           'isLocked: $isLocked, remainingAttempts: $remainingAttempts)';
  }
}