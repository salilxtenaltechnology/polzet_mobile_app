// Add these methods to your existing PinService class

// Add this PinStatus class to your pin_service.dart file
import 'package:shared_preferences/shared_preferences.dart';

class PinStatus {
  final bool isSet;
  final bool isEnabled;
  final DateTime? lastChangeDate;
  final int pinLength; // Made non-nullable with default

  PinStatus({
    required this.isSet,
    required this.isEnabled,
    this.lastChangeDate,
    this.pinLength = 4, // Default to 4 if not specified
  });
}

// Add these methods to your PinService class
class PinService {
  static const String _pinKey = 'user_pin';
  static const String _pinEnabledKey = 'pin_security_enabled';
  static const String _pinSetDateKey = 'pin_set_date';
  static const String _pinLengthKey = 'pin_length';

  // Existing methods should remain...
  
  /// Get complete PIN status information
  static Future<PinStatus> getPinStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPin = prefs.getString(_pinKey);
      final isEnabled = prefs.getBool(_pinEnabledKey) ?? false;
      final dateString = prefs.getString(_pinSetDateKey);
      final pinLength = prefs.getInt(_pinLengthKey) ?? 4; // Default to 4
      
      DateTime? lastChangeDate;
      if (dateString != null) {
        lastChangeDate = DateTime.parse(dateString);
      }

      return PinStatus(
        isSet: savedPin != null && savedPin.isNotEmpty,
        isEnabled: isEnabled,
        lastChangeDate: lastChangeDate,
        pinLength: pinLength, // No null check needed now
      );
    } catch (e) {
      return PinStatus(
        isSet: false,
        isEnabled: false,
        pinLength: 4, // Default length
      );
    }
  }

  /// Check if PIN is set (exists)
  static Future<bool> isPinSet() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPin = prefs.getString(_pinKey);
      return savedPin != null && savedPin.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Check if PIN security is enabled
  static Future<bool> isPinSecurityEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool(_pinEnabledKey) ?? false;
      final isPinSet = await PinService.isPinSet();
      return isEnabled && isPinSet;
    } catch (e) {
      return false;
    }
  }

  /// Set PIN security enabled/disabled
  static Future<void> setPinSecurityEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_pinEnabledKey, enabled);
    } catch (e) {
      throw Exception('Failed to update PIN security setting: $e');
    }
  }

  /// Save a new PIN
  static Future<bool> savePin(String pin) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Hash the PIN for security (you should implement proper hashing)
      final hashedPin = _hashPin(pin);
      
      await prefs.setString(_pinKey, hashedPin);
      await prefs.setInt(_pinLengthKey, pin.length);
      await prefs.setString(_pinSetDateKey, DateTime.now().toIso8601String());
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Verify entered PIN against saved PIN
  static Future<bool> verifyPin(String enteredPin) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedHashedPin = prefs.getString(_pinKey);
      
      if (savedHashedPin == null) {
        return false;
      }
      
      // Hash the entered PIN and compare
      final hashedEnteredPin = _hashPin(enteredPin);
      return hashedEnteredPin == savedHashedPin;
    } catch (e) {
      return false;
    }
  }

  /// Clear saved PIN data
  static Future<void> clearSavedPin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pinKey);
      await prefs.remove(_pinSetDateKey);
      await prefs.remove(_pinLengthKey);
      await prefs.setBool(_pinEnabledKey, false);
    } catch (e) {
      throw Exception('Failed to clear PIN data: $e');
    }
  }

  /// Change existing PIN (requires old PIN verification)
  static Future<bool> changePin(String oldPin, String newPin) async {
    try {
      // Verify old PIN first
      final isOldPinValid = await verifyPin(oldPin);
      if (!isOldPinValid) {
        return false;
      }
      
      // Save new PIN
      return await savePin(newPin);
    } catch (e) {
      return false;
    }
  }

  /// Simple PIN hashing (you should use a more secure method in production)
  static String _hashPin(String pin) {
    // This is a very basic hash - in production, use crypto libraries
    // like crypto package: sha256.convert(utf8.encode(pin + salt))
    int hash = 0;
    for (int i = 0; i < pin.length; i++) {
      hash = ((hash << 5) - hash) + pin.codeUnitAt(i);
      hash = hash & hash; // Convert to 32-bit integer
    }
    return hash.abs().toString();
  }
}

// Don't forget to import SharedPreferences
// import 'package:shared_preferences/shared_preferences.dart';