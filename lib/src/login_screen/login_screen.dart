// import 'package:flutter/material.dart';
// import 'package:polzet_mobile_app/Widget/app_colors.dart';
// import 'package:polzet_mobile_app/src/login_screen/forgot_password_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool _isChecked = false;
//   bool _isPasswordHidden = true;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String _errorText = '';
//
//   final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
//   final RegExp phoneRegex = RegExp(r'^\d{10}$');
//   final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
//
//   void _login() {
//     String emailOrPhone = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//
//     if (!emailRegex.hasMatch(emailOrPhone) && !phoneRegex.hasMatch(emailOrPhone)) {
//       setState(() {
//         _errorText = 'Please enter a valid email or a 10-digit contact number.';
//       });
//       return;
//     }
//
//     if (!passwordRegex.hasMatch(password)) {
//       setState(() {
//         _errorText = 'Password must be at least 8 characters long, include a letter, a number, and a special character.';
//       });
//       return;
//     }
//
//     // Placeholder for successful login
//     print('Login successful');
//   }
//
//   void _redirectToSignUp(BuildContext context) {
//     Navigator.pushNamed(context, '/email-verification');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final bool isTablet = screenWidth >= 600;
//
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: Container(
//             width: isTablet ? screenWidth * 0.6 : screenWidth * 0.9,
//             padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//             decoration: BoxDecoration(
//               boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20)],
//               borderRadius: BorderRadius.circular(20),
//               color: AppColors.WhiteColors,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTitle(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildSubtitle(),
//                   SizedBox(height: screenHeight * 0.03),
//                   _buildEmailField(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildPasswordField(),
//                   SizedBox(height: screenHeight * 0.015),
//                   _buildRememberMeAndForgotPassword(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildLoginButton(),
//                   SizedBox(height: screenHeight * 0.01),
//                   _buildSignUpRow(context),
//                   if (_errorText.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         _errorText,
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           fontFamily: "Inter",
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTitle() {
//     return Center(
//       child: Text(
//         "POLZET",
//         style: TextStyle(
//           color: AppColors.BlackColors,
//           fontSize: 36,
//           fontWeight: FontWeight.w600,
//           fontFamily: "Inter",
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSubtitle() {
//     return Text(
//       "Sign in to explore the world of POLLS",
//       style: TextStyle(
//         color: AppColors.GreyColors,
//         fontSize: 18,
//         fontWeight: FontWeight.w400,
//         fontFamily: "Inter",
//       ),
//     );
//   }
//
//   Widget _buildEmailField() {
//     return TextFormField(
//       controller: _emailController,
//       decoration: InputDecoration(
//         prefixIcon: Icon(Icons.alternate_email, color: AppColors.GreyColors2),
//         hintText: "Username or Email",
//         border: UnderlineInputBorder(
//           borderSide: BorderSide(color: AppColors.GreyColors2),
//         ),
//       ),
//       style: TextStyle(
//         color: AppColors.BlackColors,
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//         fontFamily: "Inter",
//       ),
//     );
//   }
//
//   Widget _buildPasswordField() {
//     return TextFormField(
//       controller: _passwordController,
//       obscureText: _isPasswordHidden,
//       decoration: InputDecoration(
//         prefixIcon: Icon(Icons.lock_outline, color: AppColors.GreyColors2),
//         hintText: "Password",
//         border: UnderlineInputBorder(
//           borderSide: BorderSide(color: AppColors.GreyColors2),
//         ),
//         suffixIcon: IconButton(
//           icon: Icon(
//             _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
//             color: AppColors.GreyColors2,
//           ),
//           onPressed: () {
//             setState(() {
//               _isPasswordHidden = !_isPasswordHidden;
//             });
//           },
//         ),
//       ),
//       style: TextStyle(
//         color: AppColors.BlackColors,
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//         fontFamily: "Inter",
//       ),
//     );
//   }
//
//   Widget _buildRememberMeAndForgotPassword() {
//     return Row(
//       children: [
//         Checkbox(
//           value: _isChecked,
//           onChanged: (bool? value) {
//             setState(() {
//               _isChecked = value ?? false;
//             });
//           },
//         ),
//         const SizedBox(width: 8),
//         Text(
//           "Remember me",
//           style: TextStyle(
//             color: AppColors.BlackColors,
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             fontFamily: "Inter",
//           ),
//         ),
//         const Spacer(),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
//             );
//           },
//           child: Text(
//             "Forgot Password?",
//             style: TextStyle(
//               color: const Color(0xFF9B3046),
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               fontFamily: "Inter",
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLoginButton() {
//     return Center(
//       child: Container(
//         width: double.infinity,
//         height: 48,
//         decoration: BoxDecoration(
//           border: Border.all(color: const Color(0xFF9B3046)),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: TextButton(
//           onPressed: _login,
//           child: Text(
//             "Login",
//             style: TextStyle(
//               color: const Color(0xFF9B3046),
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               fontFamily: "Inter",
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSignUpRow(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           "Don't have an account? ",
//           style: TextStyle(
//             color: AppColors.GreyColors2,
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             fontFamily: "Inter",
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             _redirectToSignUp(context);
//           },
//           child: Text(
//             "Sign up",
//             style: TextStyle(
//               color: const Color(0xFF9B3046),
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               fontFamily: "Inter",
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:polzet_mobile_app/src/login_screen/forgot_password_screen.dart';
import 'package:polzet_mobile_app/src/login_screen/email_varification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;
  bool _isPasswordHidden = true;
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorText = '';

  final RegExp passwordRegex =
  RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  final String apiUrl = 'http://44.211.191.16:8080/api/login';

  Future<void> _login() async {
    String userId = _userIdController.text.trim();
    String password = _passwordController.text.trim();

    if (!passwordRegex.hasMatch(password)) {
      setState(() {
        _errorText =
        'Password must be at least 8 characters long, include a letter, a number, and a special character.';
      });
      return;
    }

    final Map<String, String> body = {
      "username_or_email": userId,
      "password": password,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        String accessToken = responseData['access_token'] ?? '';

        if (accessToken.isNotEmpty) {
          await _saveAccessToken(accessToken);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() {
            _errorText = 'Access token not found in the response.';
          });
        }
      } else {
        setState(() {
          _errorText = 'Invalid user ID or password. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorText = 'An error occurred. Please try again later.';
      });
    }
  }

  Future<void> _saveAccessToken(String accessToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.05,
                      vertical: constraints.maxHeight * 0.02,
                    ),
                    child: _buildLoginCard(constraints),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginCard(BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.all(constraints.maxWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "POLZET",
            style: TextStyle(
                fontSize: constraints.maxWidth * 0.08,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: constraints.maxHeight * 0.01),
          Text(
            "Sign in to explore the world of POLLS",
            style: TextStyle(
                fontSize: constraints.maxWidth * 0.04, color: Colors.grey),
          ),
          SizedBox(height: constraints.maxHeight * 0.03),
          _buildUserIdField(),
          SizedBox(height: constraints.maxHeight * 0.02),
          _buildPasswordField(),
          SizedBox(height: constraints.maxHeight * 0.02),
          _buildRememberMeAndForgotPassword(constraints),
          SizedBox(height: constraints.maxHeight * 0.03),
          _buildLoginButton(),
          SizedBox(height: constraints.maxHeight * 0.02),
          _buildSignUpRow(constraints),
          if (_errorText.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.01),
              child: Text(
                _errorText,
                style: TextStyle(
                    color: Colors.red, fontSize: constraints.maxWidth * 0.035),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserIdField() {
    return TextField(
      controller: _userIdController,
      decoration: InputDecoration(
        labelText: "Email & Contact",
        labelStyle: TextStyle(color: Color(0xFFAAAAAA)), // Light Gray Color
        prefixIcon: Icon(Icons.alternate_email, color: Color(0xFFAAAAAA)), // "@" Symbol
        border: UnderlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _isPasswordHidden,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(color: Color(0xFFAAAAAA)), // Light Gray Color
        prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFAAAAAA)),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
            color: Color(0xFFAAAAAA), // Light Gray Color
          ),
          onPressed: () {
            setState(() {
              _isPasswordHidden = !_isPasswordHidden;
            });
          },
        ),
        border: UnderlineInputBorder(),
      ),
    );
  }

  Widget _buildRememberMeAndForgotPassword(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _isChecked,
              onChanged: (value) {
                setState(() {
                  _isChecked = value ?? false;
                });
              },
            ),
            Text(
              "Remember me",
              style: TextStyle(fontSize: constraints.maxWidth * 0.035),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
          ),
          child: Text(
            "Forgot password?",
            style: TextStyle(
                color: Color(0xFF9B3046),
                fontWeight: FontWeight.bold,
                fontSize: constraints.maxWidth * 0.035),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _login,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xFF9B3046)), // Border Color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Square Button
          ),
          foregroundColor: Color(0xFF9B3046), // Text Color
        ),
        child: Text("Login"),
      ),
    );
  }

  Widget _buildSignUpRow(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(fontSize: constraints.maxWidth * 0.035),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmailVerificationScreen(email: "")),
          ),
          child: Text(
            "Sign Up",
            style: TextStyle(
                color: Color(0xFF9B3046),
                fontWeight: FontWeight.bold,
                fontSize: constraints.maxWidth * 0.035),
          ),
        ),
      ],
    );
  }
}




// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:polzet_mobile_app/Widget/app_colors.dart';
// import 'package:polzet_mobile_app/src/login_screen/forgot_password_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:polzet_mobile_app/src/login_screen/email_varification_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool _isChecked = false;
//   bool _isPasswordHidden = true;
//   final TextEditingController _userIdController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String _errorText = '';
//
//   final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
//   final String apiUrl = 'http://44.211.191.16:8080/api/login';
//
//   Future<void> _login() async {
//     String userId = _userIdController.text.trim();
//     String password = _passwordController.text.trim();
//
//     if (!passwordRegex.hasMatch(password)) {
//       setState(() {
//         _errorText = 'Password must be at least 8 characters long, include a letter, a number, and a special character.';
//       });
//       return;
//     }
//
//     final Map<String, String> body = {
//       "username_or_email": userId,
//       "password": password,
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(body),
//       );
//
//       print("Response Code: ${response.statusCode}");
//       print("Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         String accessToken = responseData['access_token'] ?? '';
//         String refreshToken = responseData['refresh_token'] ?? '';
//
//         if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
//           await _saveTokens(accessToken, refreshToken);
//           Navigator.pushReplacementNamed(context, '/home');
//         } else {
//           setState(() {
//             _errorText = 'Tokens not found in response';
//           });
//         }
//       } else {
//         setState(() {
//           _errorText = 'Error: ${response.statusCode} - ${response.body}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorText = 'Connection error: $e';
//       });
//       print('Login error: $e');
//     }
//   }
//
//   // Save both tokens to SharedPreferences
//   Future<void> _saveTokens(String accessToken, String refreshToken) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('access_token', accessToken);
//     await prefs.setString('refresh_token', refreshToken);
//     print('Tokens saved successfully');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final bool isTablet = screenWidth >= 600;
//
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: Container(
//             width: isTablet ? screenWidth * 0.6 : screenWidth * 0.9,
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//             decoration: BoxDecoration(
//               boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20)],
//               borderRadius: BorderRadius.circular(20),
//               color: AppColors.WhiteColors,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTitle(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildSubtitle(),
//                   SizedBox(height: screenHeight * 0.03),
//                   _buildUserIdField(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildPasswordField(),
//                   SizedBox(height: screenHeight * 0.015),
//                   _buildRememberMeAndForgotPassword(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildLoginButton(),
//                   SizedBox(height: screenHeight * 0.01),
//                   _buildSignUpRow(),
//                   if (_errorText.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         _errorText,
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           fontFamily: "Inter",
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTitle() {
//     return Center(
//       child: Text(
//         "POLZET",
//         style: TextStyle(
//           color: AppColors.BlackColors,
//           fontSize: 36,
//           fontWeight: FontWeight.w600,
//           fontFamily: "Inter",
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSubtitle() {
//     return Text(
//       "Sign in to explore the world of POLLS",
//       style: TextStyle(
//         color: AppColors.GreyColors,
//         fontSize: 18,
//         fontWeight: FontWeight.w400,
//         fontFamily: "Inter",
//       ),
//     );
//   }
//
//   Widget _buildUserIdField() {
//     return TextFormField(
//       controller: _userIdController,
//       decoration: InputDecoration(
//         prefixIcon: Icon(Icons.person, color: AppColors.GreyColors2),
//         hintText: "Username or Email",
//         border: UnderlineInputBorder(
//           borderSide: BorderSide(color: AppColors.GreyColors2),
//         ),
//       ),
//       style: TextStyle(
//         color: AppColors.BlackColors,
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//         fontFamily: "Inter",
//       ),
//     );
//   }
//
//   Widget _buildPasswordField() {
//     return TextFormField(
//       controller: _passwordController,
//       obscureText: _isPasswordHidden,
//       decoration: InputDecoration(
//         prefixIcon: Icon(Icons.lock_outline, color: AppColors.GreyColors2),
//         hintText: "Password",
//         border: UnderlineInputBorder(
//           borderSide: BorderSide(color: AppColors.GreyColors2),
//         ),
//         suffixIcon: IconButton(
//           icon: Icon(
//             _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
//             color: AppColors.GreyColors2,
//           ),
//           onPressed: () {
//             setState(() {
//               _isPasswordHidden = !_isPasswordHidden;
//             });
//           },
//         ),
//       ),
//       style: TextStyle(
//         color: AppColors.BlackColors,
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//         fontFamily: "Inter",
//       ),
//     );
//   }
//
//   Widget _buildRememberMeAndForgotPassword() {
//     return Row(
//       children: [
//         Checkbox(
//           value: _isChecked,
//           onChanged: (bool? value) {
//             setState(() {
//               _isChecked = value ?? false;
//             });
//           },
//         ),
//         const SizedBox(width: 8),
//         Text(
//           "Remember me",
//           style: TextStyle(
//             color: AppColors.BlackColors,
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             fontFamily: "Inter",
//           ),
//         ),
//         const Spacer(),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
//             );
//           },
//           child: Text(
//             "Forgot Password?",
//             style: TextStyle(
//               color: const Color(0xFF9B3046),
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               fontFamily: "Inter",
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLoginButton() {
//     return Center(
//       child: Container(
//         width: double.infinity,
//         height: 48,
//         decoration: BoxDecoration(
//           border: Border.all(color: const Color(0xFF9B3046)),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: TextButton(
//           onPressed: _login,
//           child: Text(
//             "Login",
//             style: TextStyle(
//               color: const Color(0xFF9B3046),
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               fontFamily: "Inter",
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSignUpRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           "Don't have an account? ",
//           style: TextStyle(
//             color: AppColors.GreyColors2,
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             fontFamily: "Inter",
//           ),
//         ),
//         GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => EmailVerificationScreen()),
//           ),
//           child: Text(
//             "Sign up",
//             style: TextStyle(
//               color: const Color(0xFF9B3046),
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               fontFamily: "Inter",
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:polzet_mobile_app/Widget/app_colors.dart';
// import 'package:polzet_mobile_app/src/login_screen/forgot_password_screen.dart';
// import 'package:polzet_mobile_app/src/login_screen/email_varification_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool _isChecked = false;
//   bool _isPasswordHidden = true;
//   final TextEditingController _userIdController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String _errorText = '';
//
//   final RegExp passwordRegex =
//   RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
//   final String apiUrl = 'http://44.211.191.16:8080/api/login/';
//
//   Future<void> _login() async {
//     String userId = _userIdController.text.trim();
//     String password = _passwordController.text.trim();
//
//     if (userId.isEmpty || password.isEmpty) {
//       setState(() {
//         _errorText = 'Please enter both username/email and password.';
//       });
//       return;
//     }
//
//     if (!passwordRegex.hasMatch(password)) {
//       setState(() {
//         _errorText =
//         'Password must be at least 8 characters long, include a letter, a number, and a special character.';
//       });
//       return;
//     }
//
//     final Map<String, String> body = {
//       "username_or_email": userId,
//       "password": password,
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(body),
//       );
//
//       print("Response Code: ${response.statusCode}");
//       print("Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         String accessToken = responseData['access_token'] ?? '';
//         String refreshToken = responseData['refresh_token'] ?? '';
//
//         if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
//           await _saveTokens(accessToken, refreshToken);
//           Navigator.pushReplacementNamed(context, '/home');
//         } else {
//           setState(() {
//             _errorText = 'Invalid response from server.';
//           });
//         }
//       } else {
//         setState(() {
//           _errorText = 'Login failed. Please check your credentials.';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorText = 'Connection error. Please try again later.';
//       });
//       print('Login error: $e');
//     }
//   }
//
//   Future<void> _saveTokens(String accessToken, String refreshToken) async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('access_token', accessToken);
//       await prefs.setString('refresh_token', refreshToken);
//       print('Tokens saved successfully');
//     } catch (e) {
//       print('Error saving tokens: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final bool isTablet = screenWidth >= 600;
//
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: Container(
//             width: isTablet ? screenWidth * 0.6 : screenWidth * 0.9,
//             padding:
//             const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//             decoration: BoxDecoration(
//               boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20)],
//               borderRadius: BorderRadius.circular(20),
//               color: AppColors.WhiteColors,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTitle(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildSubtitle(),
//                   SizedBox(height: screenHeight * 0.03),
//                   _buildUserIdField(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildPasswordField(),
//                   SizedBox(height: screenHeight * 0.015),
//                   _buildRememberMeAndForgotPassword(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildLoginButton(),
//                   SizedBox(height: screenHeight * 0.01),
//                   _buildSignUpRow(),
//                   if (_errorText.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         _errorText,
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           fontFamily: "Inter",
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRememberMeAndForgotPassword() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Checkbox(
//               value: _isChecked,
//               onChanged: (bool? value) {
//                 setState(() {
//                   _isChecked = value ?? false;
//                 });
//               },
//             ),
//             const Text("Remember me"),
//           ],
//         ),
//         GestureDetector(
//           onTap: () => Navigator.push(context,
//               MaterialPageRoute(builder: (context) => ForgotPasswordScreen())),
//           child: const Text(
//             "Forgot Password?",
//             style: TextStyle(
//               color: Color(0xFF9B3046),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLoginButton() {
//     return Center(
//       child: ElevatedButton(
//         onPressed: _login,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           minimumSize: const Size(double.infinity, 48),
//           shape: RoundedRectangleBorder(
//             side: const BorderSide(color: Color(0xFF9B3046), width: 2),
//             borderRadius: BorderRadius.circular(5),
//           ),
//         ),
//         child: const Text(
//           "Login",
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF9B3046),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSignUpRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text("Don't have an account? "),
//         GestureDetector(
//           onTap: () => Navigator.pushNamed(context, '/email_verification'),
//           child: const Text(
//             "Sign up",
//             style: TextStyle(
//               color: Color(0xFF9B3046),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTitle() {
//     return Center(
//       child: Text(
//         "POLZET",
//         style: TextStyle(
//           color: AppColors.BlackColors,
//           fontSize: 36,
//           fontWeight: FontWeight.w600,
//           fontFamily: "Inter",
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSubtitle() {
//     return Text(
//       "Sign in to explore the world of POLLS",
//       style: TextStyle(
//         color: AppColors.GreyColors,
//         fontSize: 18,
//         fontWeight: FontWeight.w400,
//         fontFamily: "Inter",
//       ),
//     );
//   }
// }



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:polzet_mobile_app/Widget/app_colors.dart';
// import 'package:polzet_mobile_app/src/login_screen/forgot_password_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:polzet_mobile_app/src/login_screen/forgot_password_screen.dart';
// import 'package:polzet_mobile_app/src/login_screen/email_varification_screen.dart';
//
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool _isChecked = false;
//   bool _isPasswordHidden = true;
//   final TextEditingController _userIdController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String _errorText = '';
//
//   final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
//
//   // Static access token (hardcoded)
//   final String staticAccessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM5OTkyNTQzLCJpYXQiOjE3Mzk5OTE2NDMsImp0aSI6IjcxMGY2ZmFlOTFjYTRmZWE4NTU0ZWQzNmQ0NTBhYWQ2IiwidXNlcl9pZCI6M30.ezhSoT9uHde7YaRFh9mNCEnuTPhvLW5Olsr84ZRJdWo';
//
//   // API URL
//   final String apiUrl = 'http://44.211.191.16:8080/api/login';
//
//   // Function to make API call
//   Future<void> _login() async {
//     String userId = _userIdController.text.trim();
//     String password = _passwordController.text.trim();
//
//     // Check if password matches required pattern
//     if (!passwordRegex.hasMatch(password)) {
//       setState(() {
//         _errorText = 'Password must be at least 8 characters long, include a letter, a number, and a special character.';
//       });
//       return;
//     }
//
//     // Prepare the body for API request
//     final Map<String, String> body = {
//       "username_or_email": userId, // Sending user ID instead of email
//       "password": password,
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $staticAccessToken', // Adding token in header for Authorization
//         },
//         body: json.encode(body),
//       );
//
//       if (response.statusCode == 200) {
//         // Handle successful login response
//         final responseData = json.decode(response.body);
//         String accessToken = responseData['yJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM5MDQ2OTMxLCJpYXQiOjE3MzkwNDYwMzEsImp0aSI6ImZlNDZhNDBlYzM5ZTQyMDBhNDY4NDQ1ZTE0MjM5M2FiIiwidXNlcl9pZCI6MX0.fCLJj8bVZtTQ7c-GaRCsB2QlwlRMjPwzvLP6UfFyv2A'] ?? ''; // Extract token if available
//
//         if (accessToken.isNotEmpty) {
//           await _saveAccessToken(accessToken);
//           Navigator.pushReplacementNamed(context, '/home'); // Navigate to home screen or any other screen
//         } else {
//           setState(() {
//             _errorText = 'Access token not found in the response.';
//           });
//         }
//       } else if (response.statusCode == 400) {
//         // Handle bad request errors
//         setState(() {
//           _errorText = 'Invalid user ID or password. Please try again.';
//         });
//       } else {
//         // Handle other unexpected errors
//         setState(() {
//           _errorText = 'An unexpected error occurred. Please try again.';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorText = 'An error occurred. Please try again later.';
//       });
//       print('Error: $e');
//     }
//   }
//
//   // Save the static access token using SharedPreferences
//   Future<void> _saveAccessToken(String accessToken) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Save the token with key 'access_token'
//     await prefs.setString('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM5MDQ2OTMxLCJpYXQiOjE3MzkwNDYwMzEsImp0aSI6ImZlNDZhNDBlYzM5ZTQyMDBhNDY4NDQ1ZTE0MjM5M2FiIiwidXNlcl9pZCI6MX0.fCLJj8bVZtTQ7c-GaRCsB2QlwlRMjPwzvLP6UfFyv2A', accessToken);
//
//     print("Access Token saved: $accessToken");
//   }
//
//   void _redirectToSignUp(BuildContext context) {
//     Navigator.pushNamed(context, '/email-verification');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final bool isTablet = screenWidth >= 600;
//
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: Container(
//             width: isTablet ? screenWidth * 0.6 : screenWidth * 0.9,
//             padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//             decoration: BoxDecoration(
//               boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20)],
//               borderRadius: BorderRadius.circular(20),
//               color: AppColors.WhiteColors,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTitle(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildSubtitle(),
//                   SizedBox(height: screenHeight * 0.03),
//                   _buildUserIdField(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildPasswordField(),
//                   SizedBox(height: screenHeight * 0.015),
//                   _buildRememberMeAndForgotPassword(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildLoginButton(),
//                   SizedBox(height: screenHeight * 0.01),
//                   _buildSignUpRow(context),
//                   if (_errorText.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         _errorText,
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           fontFamily: "Inter",
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTitle() {
//     return Center(
//       child: Text(
//         "POLZET",
//         style: TextStyle(
//           color: AppColors.BlackColors,
//           fontSize: 36,
//           fontWeight: FontWeight.w600,
//           fontFamily: "Inter",
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSubtitle() {
//     return Text(
//       "Sign in to explore the world of POLLS",
//       style: TextStyle(
//         color: AppColors.GreyColors,
//         fontSize: 18,
//         fontWeight: FontWeight.w400,
//         fontFamily: "Inter",
//       ),
//     );
//   }
//
//   Widget _buildUserIdField() {
//     return TextFormField(
//       controller: _userIdController,
//       decoration: InputDecoration(
//         prefixIcon: Icon(Icons.person, color: AppColors.GreyColors2),
//         hintText: "User ID",
//         border: UnderlineInputBorder(
//           borderSide: BorderSide(color: AppColors.GreyColors2),
//         ),
//       ),
//       style: TextStyle(
//         color: AppColors.BlackColors,
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//         fontFamily: "Inter",
//       ),
//     );
//   }
//
//   Widget _buildPasswordField() {
//     return TextFormField(
//       controller: _passwordController,
//       obscureText: _isPasswordHidden,
//       decoration: InputDecoration(
//         prefixIcon: Icon(Icons.lock_outline, color: AppColors.GreyColors2),
//         hintText: "Password",
//         border: UnderlineInputBorder(
//           borderSide: BorderSide(color: AppColors.GreyColors2),
//         ),
//         suffixIcon: IconButton(
//           icon: Icon(
//             _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
//             color: AppColors.GreyColors2,
//           ),
//           onPressed: () {
//             setState(() {
//               _isPasswordHidden = !_isPasswordHidden;
//             });
//           },
//         ),
//       ),
//       style: TextStyle(
//         color: AppColors.BlackColors,
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//         fontFamily: "Inter",
//       ),
//     );
//   }
//
//   Widget _buildRememberMeAndForgotPassword() {
//     return Row(
//       children: [
//         Checkbox(
//           value: _isChecked,
//           onChanged: (bool? value) {
//             setState(() {
//               _isChecked = value ?? false;
//             });
//           },
//         ),
//         const SizedBox(width: 8),
//         Text(
//           "Remember me",
//           style: TextStyle(
//             color: AppColors.BlackColors,
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             fontFamily: "Inter",
//           ),
//         ),
//         const Spacer(),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
//             );
//           },
//           child: Text(
//             "Forgot Password?",
//             style: TextStyle(
//               color: const Color(0xFF9B3046),
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               fontFamily: "Inter",
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLoginButton() {
//     return Center(
//       child: Container(
//         width: double.infinity,
//         height: 48,
//         decoration: BoxDecoration(
//           border: Border.all(color: const Color(0xFF9B3046)),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: TextButton(
//           onPressed: _login,
//           child: Text(
//             "Login",
//             style: TextStyle(
//               color: const Color(0xFF9B3046),
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               fontFamily: "Inter",
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSignUpRow(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           "Don't have an account? ",
//           style: TextStyle(
//             color: AppColors.GreyColors2,
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             fontFamily: "Inter",
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             _redirectToSignUp(context);
//           },
//           child: Text(
//             "Sign up",
//             style: TextStyle(
//               color: const Color(0xFF9B3046),
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               fontFamily: "Inter",
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }





// import 'dart:convert'; // For JSON decoding
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http; // Import http package
// import 'package:polzet_mobile_app/Widget/app_colors.dart';
// import 'package:polzet_mobile_app/src/login_screen/forgot_password_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'data/model/login_model.dart'; // For saving the access token
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool _isChecked = false;
//   bool _isPasswordHidden = true;
//   final TextEditingController _userIdController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String _errorText = '';
//
//   final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
//
//   // API URL
//   final String apiUrl = 'http://44.211.191.16:8080/api/login';
//
//   // Function to make API call
//   Future<void> _login() async {
//     String userId = _userIdController.text.trim();
//     String password = _passwordController.text.trim();
//
//     // Check if password matches required pattern
//     if (!passwordRegex.hasMatch(password)) {
//       setState(() {
//         _errorText = 'Password must be at least 8 characters long, include a letter, a number, and a special character.';
//       });
//       return;
//     }
//
//     // Prepare the body for API request
//     final Map<String, String> body = {
//       "user_id": userId, // Sending user ID instead of email
//       "password": password,
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(body),
//       );
//
//       if (response.statusCode == 200) {
//         // Successfully logged in
//         // Save the access token from the response
//         var responseJson = json.decode(response.body);
//         String accessToken = responseJson['eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM5MDQ0MjEzLCJpYXQiOjE3MzkwNDMzMTMsImp0aSI6ImFiZjViMzBkOGVmZjQ2ODk4YmE5ZmIwMTJkNjRjMzRiIiwidXNlcl9pZCI6MX0.WhyrV8JSnO9PyldzgiZofYESS9kIxy9ytDFdgM2en3g'];
//         await _saveAccessToken(accessToken);
//         Navigator.pushReplacementNamed(context, '/home'); // Navigate to home screen or any other screen
//       } else {
//         setState(() {
//           _errorText = 'Invalid user ID or password.';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorText = 'An error occurred. Please try again.';
//       });
//       print('Error: $e');
//     }
//   }
//
//   // Save the access token using SharedPreferences
//   Future<void> _saveAccessToken(String accessToken) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Save token with key 'access_token'
//     await prefs.setString('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM5MDQ0MjEzLCJpYXQiOjE3MzkwNDMzMTMsImp0aSI6ImFiZjViMzBkOGVmZjQ2ODk4YmE5ZmIwMTJkNjRjMzRiIiwidXNlcl9pZCI6MX0.WhyrV8JSnO9PyldzgiZofYESS9kIxy9ytDFdgM2en3g', accessToken);
//
//     print("Access Token saved: $accessToken");
//   }
//
//   void _redirectToSignUp(BuildContext context) {
//     Navigator.pushNamed(context, '/email-verification');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final bool isTablet = screenWidth >= 600;
//
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: Container(
//             width: isTablet ? screenWidth * 0.6 : screenWidth * 0.9,
//             padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//             decoration: BoxDecoration(
//               boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20)],
//               borderRadius: BorderRadius.circular(20),
//               color: AppColors.WhiteColors,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTitle(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildSubtitle(),
//                   SizedBox(height: screenHeight * 0.03),
//                   _buildUserIdField(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildPasswordField(),
//                   SizedBox(height: screenHeight * 0.015),
//                   _buildRememberMeAndForgotPassword(),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildLoginButton(),
//                   SizedBox(height: screenHeight * 0.01),
//                   _buildSignUpRow(context),
//                   if (_errorText.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         _errorText,
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           fontFamily: "Inter",
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTitle() {
//     return Center(
//       child: Text(
//         "POLZET",
//         style: TextStyle(
//           color: AppColors.BlackColors,
//           fontSize: 36,
//           fontWeight: FontWeight.w600,
//           fontFamily: "Inter",
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSubtitle() {
//     return Text(
//       "Sign in to explore the world of POLLS",
//       style: TextStyle(
//         color: AppColors.GreyColors,
//         fontSize: 18,
//         fontWeight: FontWeight.w400,
//         fontFamily: "Inter",
//       ),
//     );
//   }
//
//   Widget _buildUserIdField() {
//     return TextFormField(
//       controller: _userIdController,
//       decoration: InputDecoration(
//         prefixIcon: Icon(Icons.person, color: AppColors.GreyColors2),
//         hintText: "User ID",
//         border: UnderlineInputBorder(
//           borderSide: BorderSide(color: AppColors.GreyColors2),
//         ),
//       ),
//       style: TextStyle(
//         color: AppColors.BlackColors,
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//         fontFamily: "Inter",
//       ),
//     );
//   }
//
//   Widget _buildPasswordField() {
//     return TextFormField(
//       controller: _passwordController,
//       obscureText: _isPasswordHidden,
//       decoration: InputDecoration(
//         prefixIcon: Icon(Icons.lock_outline, color: AppColors.GreyColors2),
//         hintText: "Password",
//         border: UnderlineInputBorder(
//           borderSide: BorderSide(color: AppColors.GreyColors2),
//         ),
//         suffixIcon: IconButton(
//           icon: Icon(
//             _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
//             color: AppColors.GreyColors2,
//           ),
//           onPressed: () {
//             setState(() {
//               _isPasswordHidden = !_isPasswordHidden;
//             });
//           },
//         ),
//       ),
//       style: TextStyle(
//         color: AppColors.BlackColors,
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//         fontFamily: "Inter",
//       ),
//     );
//   }
//
//   Widget _buildRememberMeAndForgotPassword() {
//     return Row(
//       children: [
//         Checkbox(
//           value: _isChecked,
//           onChanged: (bool? value) {
//             setState(() {
//               _isChecked = value ?? false;
//             });
//           },
//         ),
//         const SizedBox(width: 8),
//         Text(
//           "Remember me",
//           style: TextStyle(
//             color: AppColors.BlackColors,
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             fontFamily: "Inter",
//           ),
//         ),
//         const Spacer(),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
//             );
//           },
//           child: Text(
//             "Forgot Password?",
//             style: TextStyle(
//               color: const Color(0xFF9B3046),
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               fontFamily: "Inter",
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLoginButton() {
//     return Center(
//       child: Container(
//         width: double.infinity,
//         height: 48,
//         decoration: BoxDecoration(
//           border: Border.all(color: const Color(0xFF9B3046)),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: TextButton(
//           onPressed: _login,
//           child: Text(
//             "Login",
//             style: TextStyle(
//               color: const Color(0xFF9B3046),
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               fontFamily: "Inter",
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSignUpRow(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           "Don't have an account? ",
//           style: TextStyle(
//             color: AppColors.GreyColors2,
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             fontFamily: "Inter",
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             _redirectToSignUp(context);
//           },
//           child: Text(
//             "Sign up",
//             style: TextStyle(
//               color: const Color(0xFF9B3046),
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               fontFamily: "Inter",
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

