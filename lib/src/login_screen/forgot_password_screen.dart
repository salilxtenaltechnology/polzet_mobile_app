import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // For SocketException
import 'dart:async'; // For TimeoutException

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
  List.generate(6, (index) => FocusNode());

  bool _isEmailSent = false; // To track if OTP has been sent
  bool _isLoading = false; // To show loading state
  String _errorText = ''; // To display error messages

  // Validate email format
  bool _isValidEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  // Send OTP to the user's email
  Future<void> _sendOtp() async {
    if (!_isValidEmail(_emailController.text)) {
      setState(() => _errorText = 'Please enter a valid email address.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://your-api-url/api/forgot_password_email'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          "email": _emailController.text,
        }),
      ).timeout(const Duration(seconds: 15));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _isEmailSent = true; // OTP sent successfully
          _errorText = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent to your email.')),
        );
      } else {
        setState(() => _errorText = responseData['error']?.toString() ??
            'Failed to send OTP. Please try again.');
      }
    } on SocketException {
      setState(() => _errorText = 'Network error: Check internet connection.');
    } on TimeoutException {
      setState(() => _errorText = 'Connection timeout. Please try again.');
    } catch (e) {
      setState(() => _errorText = 'Error: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Verify OTP entered by the user
  Future<void> _verifyOtp() async {
    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length < 6 || otp.contains(RegExp(r'[^0-9]'))) {
      setState(() => _errorText = 'Please enter a valid 6-digit OTP.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://your-api-url/api/forgot_password_verify'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          "email": _emailController.text,
          "otp": otp,
        }),
      ).timeout(const Duration(seconds: 15));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verified successfully.')),
        );
        // Navigate to the reset password screen or perform other actions
      } else {
        setState(() => _errorText = responseData['error']?.toString() ??
            'Invalid OTP. Please try again.');
      }
    } on SocketException {
      setState(() => _errorText = 'Network error: Check internet connection.');
    } on TimeoutException {
      setState(() => _errorText = 'Connection timeout. Please try again.');
    } catch (e) {
      setState(() => _errorText = 'Error: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final bool isTablet = SizerUtil.deviceType == DeviceType.tablet;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: isTablet ? (isPortrait ? 70.w : 50.w) : (isPortrait ? 90.w : 70.w),
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 4.w : 5.w,
                vertical: isTablet ? 3.h : 4.h,
              ),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2.w)],
                borderRadius: BorderRadius.circular(2.w),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: isTablet ? 20.sp : 24.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 2.h : 3.h),

                  // Email Input
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: TextStyle(
                        color: const Color(0xFFAAAAAA),
                        fontSize: isTablet ? 12.sp : 14.sp,
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
                    ),
                    style: TextStyle(
                      fontSize: isTablet ? 12.sp : 14.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                    ),
                  ),
                  SizedBox(height: isTablet ? 2.h : 3.h),

                  // Send OTP Button
                  if (!_isEmailSent)
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: isTablet ? 40.w : 50.w,
                          maxWidth: 80.w,
                        ),
                        child: Container(
                          height: isTablet ? 5.h : 6.h,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF9B3046)),
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: TextButton(
                            onPressed: _isLoading ? null : _sendOtp,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF9B3046),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Color(0xFF9B3046))
                                : Text(
                              "Send OTP",
                              style: TextStyle(
                                fontSize: isTablet ? 12.sp : 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Inter",
                                color: const Color(0xFF9B3046),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // OTP Section (Visible only after OTP is sent)
                  if (_isEmailSent) ...[
                    SizedBox(height: isTablet ? 3.h : 4.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          final boxSize = isTablet
                              ? (isPortrait ? 8.w : 6.w)
                              : 12.w;

                          return SizedBox(
                            width: boxSize,
                            height: boxSize,
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _otpFocusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1),
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFFD9D9D9),
                                    width: 0.5.w,
                                  ),
                                  borderRadius: BorderRadius.circular(2.w),
                                ),
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(
                                fontSize: isTablet ? 12.sp : 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  if (index < 5) {
                                    FocusScope.of(context).requestFocus(
                                        _otpFocusNodes[index + 1]);
                                  } else {
                                    FocusScope.of(context).unfocus();
                                  }
                                }
                              },
                            ),
                          );
                        }),
                      ),
                    ),

                    // Verify OTP Button
                    SizedBox(height: isTablet ? 2.h : 3.h),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: isTablet ? 40.w : 50.w,
                          maxWidth: 80.w,
                        ),
                        child: Container(
                          height: isTablet ? 5.h : 6.h,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF9B3046)),
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: TextButton(
                            onPressed: _isLoading ? null : _verifyOtp,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF9B3046),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Color(0xFF9B3046))
                                : Text(
                              "Verify OTP",
                              style: TextStyle(
                                fontSize: isTablet ? 12.sp : 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Inter",
                                color: const Color(0xFF9B3046),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Error Message
                  if (_errorText.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        _errorText,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: isTablet ? 10.sp : 12.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                  SizedBox(height: isTablet ? 2.h : 3.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}