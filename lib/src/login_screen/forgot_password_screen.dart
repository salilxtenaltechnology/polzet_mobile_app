import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // For SocketException
import 'package:polzet_mobile_app/src/login_screen/Change_password.dart';
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
  bool _isSendingOtp = false; // To show loading state for OTP sending
  String _errorMessage = ''; // To display error messages
  String _successMessage = ''; // To display success messages

  // API endpoints
  final String _forgotPasswordSendUrl = 'http://44.211.191.16:8080/api/forgot_password_email';
  final String _forgotPasswordVerifyUrl = 'http://44.211.191.16:8080/api/forgot_password_verify';

  // Validate email format
  bool _isValidEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  // Send OTP to the user's email
  Future<void> _sendOtp() async {
    if (!_isValidEmail(_emailController.text)) {
      setState(() => _errorMessage = 'Please enter a valid email address.');
      return;
    }

    setState(() {
      _isSendingOtp = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse(_forgotPasswordSendUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': _emailController.text}),
      ).timeout(const Duration(seconds: 15));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _isEmailSent = true;
          _successMessage = 'OTP sent successfully!';
        });
      } else if (response.statusCode == 404) {
        setState(() => _errorMessage = 'User with this email does not exist.');
      } else {
        setState(() => _errorMessage = responseData['message'] ?? 'Failed to send OTP');
      }
    } on SocketException {
      setState(() => _errorMessage = 'Network error: Check internet connection.');
    } on TimeoutException {
      setState(() => _errorMessage = 'Connection timeout. Please try again.');
    } catch (e) {
      setState(() => _errorMessage = 'Error: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      setState(() => _isSendingOtp = false);
    }
  }

  // Verify OTP entered by the user
  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6) {
      setState(() => _errorMessage = 'Please enter all 6 digits');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse(_forgotPasswordVerifyUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'otp': otp,
        }),
      ).timeout(const Duration(seconds: 15));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Navigate to the ChangePasswordScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePasswordScreen(email: _emailController.text),
          ),
        );
      } else {
        setState(() => _errorMessage = responseData['message'] ?? 'Invalid OTP');
      }
    } on SocketException {
      setState(() => _errorMessage = 'Network error: Check internet connection.');
    } on TimeoutException {
      setState(() => _errorMessage = 'Connection timeout. Please try again.');
    } catch (e) {
      setState(() => _errorMessage = 'Error: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
                      "Forgot Password",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: isTablet ? 12.sp : 14.sp,
                        fontWeight: FontWeight.w300,
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.alternate_email, color: Colors.grey, size: 14.sp),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: "Email or Contact",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter",
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Inter",
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _isSendingOtp ? null : _sendOtp,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF0E4FF),
                                  borderRadius: BorderRadius.circular(1.w),
                                ),
                                child: _isSendingOtp
                                    ? SizedBox(
                                  width: 14.sp,
                                  height: 14.sp,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                                    : Text(
                                    "Get OTP",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Inter",
                                    )),
                              ),
                            ),
                          ],
                        ),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 1.h),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        if (_successMessage.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 1.h),
                            child: Text(
                              _successMessage,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        Container(height: 0.1.h, color: Colors.grey),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final totalWidth = constraints.maxWidth;
                        final boxSize = totalWidth / 8;
                        final boxSpacing = 3.w;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: boxSpacing / 2),
                              child: SizedBox(
                                width: boxSize,
                                height: boxSize * 1.1,
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _otpFocusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  cursorColor: Color(0xFF9B3046),
                                  cursorHeight: 16.sp,
                                  cursorWidth: 1.5,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: _otpFocusNodes[index].hasFocus
                                            ? Color(0xFF9B3046)
                                            : Color(0xFFD9D9D9),
                                        width: 1.2,
                                      ),
                                      borderRadius: BorderRadius.circular(0.8.w),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Inter",
                                  ),
                                  onChanged: (value) {
                                    setState(() => _errorMessage = '');
                                    if (value.isNotEmpty) {
                                      if (index < 5) {
                                        FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
                                      } else {
                                        FocusScope.of(context).unfocus();
                                      }
                                    } else {
                                      if (index > 0) {
                                        FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
                                      }
                                    }
                                  },
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    child: Container(
                      height: 5.5.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF9B3046), width: 1.3),
                        borderRadius: BorderRadius.circular(2.w),
                        color: Colors.transparent,
                      ),
                      child: TextButton(
                        onPressed: _isLoading ? null : _verifyOtp,
                        child: Center(
                          child: _isLoading
                              ? CircularProgressIndicator(color: Color(0xFF9B3046))
                              : Text(
                              "Verify OTP",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Inter",
                                color: Color(0xFF9B3046),
                              )),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Remember your password? ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Color(0xFF9B3046),
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                                fontFamily: "Inter",
                              ),
                            ),
                          ),
                        ],
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

  @override
  void dispose() {
    for (var controller in _otpControllers) controller.dispose();
    for (var node in _otpFocusNodes) node.dispose();
    super.dispose();
  }
}