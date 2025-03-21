// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sizer/sizer.dart';
//
// class EmailVerificationScreen extends StatefulWidget {
//   @override
//   _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
// }
//
// class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final List<TextEditingController> _otpControllers =
//   List.generate(6, (index) => TextEditingController());
//   final List<FocusNode> _otpFocusNodes =
//   List.generate(6, (index) => FocusNode());
//
//   bool _isChecked = false;
//
//   void _verifyOtp() {
//     // Your OTP verification logic
//   }
//
//   void _redirectToLogin(BuildContext context) {
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//     final bool isTablet = MediaQuery.of(context).size.width > 600;
//
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: SingleChildScrollView(
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
//               width: isTablet ? (isPortrait ? 70.w : 50.w) : 90.w,
//               decoration: BoxDecoration(
//                 boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2.w)],
//                 borderRadius: BorderRadius.circular(5.w),
//                 color: Colors.white,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Text(
//                       "POLZET",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: isTablet ? 22.sp : 25.sp,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: "Inter",
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                   Center(
//                     child: Text(
//                       "Verify Your Email",
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: isTablet ? 14.sp : 16.sp,
//                         fontWeight: FontWeight.w400,
//                         fontFamily: "Inter",
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 3.h),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 5.w),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Icon(Icons.alternate_email, color: Colors.grey, size: 16.sp),
//                             SizedBox(width: 2.w),
//                             Expanded(
//                               child: TextFormField(
//                                 controller: _emailController,
//                                 decoration: InputDecoration(
//                                   hintText: "Email or Contact",
//                                   hintStyle: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 15.sp,
//                                     fontWeight: FontWeight.w400,
//                                     fontFamily: "Inter",
//                                   ),
//                                   border: InputBorder.none,
//                                 ),
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.w400,
//                                   fontFamily: "Inter",
//                                 ),
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {/* Add OTP generation logic */},
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
//                                 decoration: BoxDecoration(
//                                   color: Color(0xFFF0E4FF),
//                                   borderRadius: BorderRadius.circular(1.w),
//                                 ),
//                                 child: Text(
//                                   "Generate OTP",
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 13.5.sp,
//                                     fontWeight: FontWeight.w500,
//                                     fontFamily: "Inter",
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Container(height: 0.1.h, color: Colors.grey),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 3.h),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 5.w),
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         final totalWidth = constraints.maxWidth;
//                         final boxSize = totalWidth / 8; // Increased size slightly
//                         final boxSpacing = 3.w; // Reduced spacing between boxes
//
//                         return Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: List.generate(6, (index) {
//                             return Padding(
//                               padding: EdgeInsets.symmetric(horizontal: boxSpacing / 2),
//                               child: SizedBox(
//                                 width: boxSize,
//                                 height: boxSize * 1.2, // Slightly taller for better input
//                                 child: TextField(
//                                   controller: _otpControllers[index],
//                                   focusNode: _otpFocusNodes[index],
//                                   keyboardType: TextInputType.number,
//                                   textAlign: TextAlign.center,
//                                   cursorColor: Color(0xFF9B3046),
//                                   cursorHeight: 18.sp,
//                                   cursorWidth: 2,
//                                   inputFormatters: [
//                                     FilteringTextInputFormatter.digitsOnly,
//                                     LengthLimitingTextInputFormatter(1),
//                                   ],
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: _otpFocusNodes[index].hasFocus
//                                             ? Color(0xFF9B3046)
//                                             : Color(0xFFD9D9D9),
//                                         width: 1.5, // Slightly thicker border for better visibility
//                                       ),
//                                       borderRadius: BorderRadius.circular(0.8.w),
//                                     ),
//                                     contentPadding: EdgeInsets.zero,
//                                   ),
//                                   style: TextStyle(
//                                     fontSize: 18.sp, // Increased font size for better readability
//                                     fontWeight: FontWeight.w500,
//                                     fontFamily: "Inter",
//                                   ),
//                                   onChanged: (value) {
//                                     if (value.isNotEmpty) {
//                                       if (index < 5) {
//                                         FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
//                                       } else {
//                                         FocusScope.of(context).unfocus();
//                                       }
//                                     }
//                                   },
//                                 ),
//                               ),
//                             );
//                           }),
//                         );
//                       },
//                     ),
//                   ),
//
//                   SizedBox(height: 1.7.h),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 2.w),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Checkbox(
//                           value: _isChecked,
//                           onChanged: (bool? value) {
//                             setState(() {
//                               _isChecked = value ?? false;
//                             });
//                           },
//                           activeColor: Color(0xFF9B3046),
//                         ),
//                         SizedBox(width: 0.w),
//                         Text(
//                           "Remember me",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w400,
//                             fontFamily: "Inter",
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
//                     child: Container(
//                       height: 6.h,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Color(0xFF9B3046), width: 1.5), // Bordered button
//                         borderRadius: BorderRadius.circular(2.w),
//                         color: Colors.transparent, // No background color
//                       ),
//                       child: TextButton(
//                         onPressed: _verifyOtp,
//                         child: Center(
//                           child: Text(
//                             "Verify OTP",
//                             style: TextStyle(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w600,
//                               fontFamily: "Inter",
//                               color: Color(0xFF9B3046), // Text color same as border
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Center(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 2.h),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Have an account? ",
//                             style: TextStyle(
//                               color: Colors.black, // Keep "Have an account?" in black
//                               fontSize: 14.5.sp,
//                               fontWeight: FontWeight.w400,
//                               fontFamily: "Inter",
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () => _redirectToLogin(context),
//                             child: Text(
//                               "Login",
//                               style: TextStyle(
//                                 color: Color(0xFF9B3046), // Change only "Login" to colored
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14.5.sp,
//                                 fontFamily: "Inter",
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart'; // ✅ Import Pinput for OTP fields
//
// class EmailVerificationScreen extends StatefulWidget {
//   final String email; // ✅ Accept email parameter
//
//   const EmailVerificationScreen({Key? key, required this.email}) : super(key: key);
//
//   @override
//   _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
// }
//
// class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
//   final TextEditingController otpController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Verify Your Email",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//
//               // ✅ Display Email Address
//               Text(
//                 "A verification code has been sent to: \n${widget.email}",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//
//               const SizedBox(height: 20),
//
//               // ✅ Email & Contact in the same row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       decoration: const InputDecoration(labelText: "Email"),
//                       initialValue: widget.email,
//                       readOnly: true,
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: TextFormField(
//                       decoration: const InputDecoration(labelText: "Contact"),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               // ✅ Generate OTP Button
//               ElevatedButton(
//                 onPressed: () {
//                   // TODO: Add OTP generation logic
//                 },
//                 child: const Text("Generate OTP"),
//               ),
//
//               const SizedBox(height: 20),
//
//               // ✅ OTP Input using Pinput
//               Pinput(
//                 controller: otpController,
//                 length: 6,
//                 showCursor: true,
//                 defaultPinTheme: PinTheme(
//                   width: 50,
//                   height: 50,
//                   textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.blue),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // ✅ Verify Button (Bordered)
//               OutlinedButton(
//                 onPressed: () {
//                   // TODO: Verify OTP logic
//                 },
//                 child: const Text("Verify"),
//               ),
//
//               const SizedBox(height: 20),
//
//               // ✅ "Have an account? Login" link
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text("Have an account? Login"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:polzet_mobile_app/src/login_screen/singup_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({Key? key, required this.email}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());
  bool _isChecked = false;
  bool _isLoading = false;
  bool _isSendingOtp = false;
  String _errorMessage = '';
  String _successMessage = '';

  // API endpoints
  final String _emailVerificationUrl = 'http://44.211.191.16:8080/api/email_verification';
  final String _validateOtpUrl = 'http://44.211.191.16:8080/api/validate_otp';

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  Future<void> _sendOtp() async {
    if (!_validateEmail(_emailController.text)) {
      setState(() => _errorMessage = 'Please enter a valid email address');
      return;
    }

    setState(() {
      _isSendingOtp = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse(_emailVerificationUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': _emailController.text}),
      );

      if (response.statusCode == 200) {
        setState(() => _successMessage = 'OTP sent successfully!');
      } else {
        final errorData = json.decode(response.body);
        setState(() => _errorMessage = errorData['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Connection error: ${e.toString()}');
    } finally {
      setState(() => _isSendingOtp = false);
    }
  }

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
        Uri.parse(_validateOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        // Redirect to SignupScreen with email
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignupScreen(email: _emailController.text),
          ),
        );
      } else {
        final errorData = json.decode(response.body);
        setState(() => _errorMessage = errorData['message'] ?? 'Invalid OTP');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Connection error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _validateEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
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
                      "Verify Your Email",
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
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) => setState(() => _isChecked = value ?? false),
                          activeColor: Color(0xFF9B3046),
                        ),
                        Text(
                          "Remember me",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                          ),
                        ),
                      ],
                    ),
                  ),
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
                            "Have an account? ",
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

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sizer/sizer.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class EmailVerificationScreen extends StatefulWidget {
//   final String email;
//
//   EmailVerificationScreen({required this.email});
//
//   @override
//   _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
// }
//
// class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
//   final List<TextEditingController> _otpControllers =
//   List.generate(6, (index) => TextEditingController());
//   final List<FocusNode> _otpFocusNodes =
//   List.generate(6, (index) => FocusNode());
//   bool _isChecked = false;
//   bool _isLoading = false;
//
//   Future<void> _sendOtp() async {
//     setState(() => _isLoading = true);
//     final response = await http.post(
//       Uri.parse("http://44.211.191.16:8080/api/email_verification"),
//       body: jsonEncode({"email": widget.email}),
//       headers: {"Content-Type": "application/json"},
//     );
//     setState(() => _isLoading = false);
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("OTP Sent Successfully")));
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Failed to send OTP")));
//     }
//   }
//
//   Future<void> _verifyOtp() async {
//     String otp = _otpControllers.map((c) => c.text).join();
//     if (otp.length < 6) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Enter full OTP")));
//       return;
//     }
//     setState(() => _isLoading = true);
//     final response = await http.post(
//       Uri.parse("http://44.211.191.16:8080/api/validate_otp"),
//       body: jsonEncode({"email": widget.email, "otp": otp}),
//       headers: {"Content-Type": "application/json"},
//     );
//     setState(() => _isLoading = false);
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("OTP Verified!")));
//       // Navigate to next screen
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Invalid OTP")));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Verify Your Email", style: TextStyle(fontSize: 18.sp)),
//               SizedBox(height: 3.h),
//               Text(widget.email, style: TextStyle(color: Colors.grey)),
//               SizedBox(height: 3.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(6, (index) {
//                   return Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 2.w),
//                     child: SizedBox(
//                       width: 10.w,
//                       height: 10.w,
//                       child: TextField(
//                         controller: _otpControllers[index],
//                         focusNode: _otpFocusNodes[index],
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           LengthLimitingTextInputFormatter(1),
//                         ],
//                         decoration: InputDecoration(border: OutlineInputBorder()),
//                         onChanged: (value) {
//                           if (value.isNotEmpty && index < 5) {
//                             FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
//                           }
//                         },
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//               SizedBox(height: 3.h),
//               _isLoading
//                   ? CircularProgressIndicator()
//                   : ElevatedButton(
//                 onPressed: _verifyOtp,
//                 child: Text("Verify OTP"),
//               ),
//               TextButton(
//                 onPressed: _sendOtp,
//                 child: Text("Resend OTP"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
