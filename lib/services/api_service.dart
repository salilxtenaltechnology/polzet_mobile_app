import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://44.211.191.16:8080/api/";

  /// 🔹 1. Send Email Verification (Generates OTP)
  static Future<dynamic> sendEmailVerification(String email) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}email_verification/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      print("📩 Email Verification Response: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("❌ Email Verification Failed: ${response.body}");
      }
    } catch (e) {
      print("❌ API Error: $e");
      return null;
    }
  }

  /// 🔹 2. Validate OTP
  static Future<dynamic> validateOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}validate_otp/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp}),
      );

      print("🔢 OTP Validation Response: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("❌ OTP Validation Failed: ${response.body}");
      }
    } catch (e) {
      print("❌ API Error: $e");
      return null;
    }
  }

  /// 🔹 3. Signup API
  static Future<dynamic> signUp(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}signup/"), // Make sure this is the correct endpoint
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      print("📝 Signup Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("❌ Signup Failed: ${response.body}");
      }
    } catch (e) {
      print("❌ API Error: $e");
      return null;
    }
  }

  /// 🔹 4. Login API
  static Future<dynamic> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}login/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("🔑 Login Response: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("❌ Login Failed: ${response.body}");
      }
    } catch (e) {
      print("❌ API Error: $e");
      return null;
    }
  }
}
