import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'dart:convert'; // For JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart'; // For storing the access token

class ChangePasswordScreen extends StatefulWidget {
  final String email;

  const ChangePasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  bool _isLoading = false;
  String _errorMessage = '';

  // Validate password and confirm password
  bool _validatePassword() {
    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields.');
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return false;
    }

    if (_passwordController.text.length < 8) {
      setState(() => _errorMessage = 'Password must be at least 8 characters.');
      return false;
    }

    setState(() => _errorMessage = '');
    return true;
  }

  // Submit new password
  // ... (keep imports and widget definition)

  Future<void> _submitNewPassword() async {
    if (!_validatePassword()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        setState(() => _errorMessage = 'Authentication token not found. Please log in again.');
        return;
      }

      final url = Uri.parse('http://44.211.191.16:8080/api/update_password');
      final body = jsonEncode({
        'email': widget.email,
        'new_password': _passwordController.text,
        'confirm_password': _confirmPasswordController.text,
      });

      print('Request Body: $body');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      print('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully!'),
            duration: Duration(seconds: 3),
          ),
        );
        Future.delayed(const Duration(seconds: 3), () => Navigator.pop(context));
      } else {
        final responseData = jsonDecode(response.body);
        String errorMessage;
        switch (response.statusCode) {
          case 400:
            errorMessage = responseData['message'] ?? 'Invalid request. Check your input.';
            break;
          case 401:
            errorMessage = 'Session expired. Please log in again.';
            break;
          case 500:
            errorMessage = 'Server error. Try again later.';
            break;
          default:
            errorMessage = 'Failed to change password.';
        }
        setState(() => _errorMessage = errorMessage);
      }
    } catch (e) {
      print('Error: $e');
      setState(() => _errorMessage = 'Network error. Check your connection.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

// ... (rest of the code remains the same)

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final bool isTablet = MediaQuery.of(context).size.width > 600;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
              width: isTablet ? (isPortrait ? 70.w : 50.w) : 90.w,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2.w)],
                borderRadius: BorderRadius.circular(5.w),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Text(
                      "POLZET",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: isTablet ? 20.sp : 22.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Center(
                    child: Text(
                      "Password to explore the world of POLLS",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: isTablet ? 12.sp : 14.sp,
                        fontWeight: FontWeight.w300,
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Email Display
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      widget.email,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Password Field
                  _buildPasswordField("Password", _passwordController, _isPasswordHidden, () {
                    setState(() => _isPasswordHidden = !_isPasswordHidden);
                  }),
                  SizedBox(height: 2.h),

                  // Confirm Password Field
                  _buildPasswordField("Confirm Password", _confirmPasswordController, _isConfirmPasswordHidden, () {
                    setState(() => _isConfirmPasswordHidden = !_isConfirmPasswordHidden);
                  }),
                  SizedBox(height: 2.h),

                  // Error Message
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  SizedBox(height: 2.h),

                  // Done Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Container(
                      height: 5.5.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF9B3046), width: 1.3),
                        borderRadius: BorderRadius.circular(2.w),
                        color: Colors.transparent,
                      ),
                      child: TextButton(
                        onPressed: _isLoading ? null : _submitNewPassword,
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Color(0xFF9B3046))
                              : Text(
                              "Done",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Inter",
                                color: const Color(0xFF9B3046),
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hint, TextEditingController controller, bool isHidden, VoidCallback toggleVisibility) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: TextFormField(
        controller: controller,
        obscureText: isHidden,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            fontFamily: "Inter",
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFFD9D9D9),
              width: 0.5.w,
            ),
            borderRadius: BorderRadius.circular(2.w),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isHidden ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: toggleVisibility,
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          fontFamily: "Inter",
        ),
      ),
    );
  }
}