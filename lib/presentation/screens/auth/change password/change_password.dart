// ignore_for_file: deprecated_member_use
import 'package:dio/dio.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../api/app_api.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../common widgets/custom_card.dart';
import '../../../common widgets/show_toast.dart';
import '../../../common widgets/text field/primary_textfield.dart';
import '../../../common widgets/button/auth_button.dart';
import '../../../common widgets/custom_text_styles.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;
  final String JWT_TOKEN;

  const ChangePasswordScreen(
      {Key? key, required this.email, required this.JWT_TOKEN})
      : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  bool _isLoading = false;
  String _errorText = '';

  // Validate password and confirm password
  // bool _validatePassword() {
  //   if (_passwordController.text.isEmpty ||
  //       _confirmPasswordController.text.isEmpty) {
  //     setState(() => _errorText = 'Please fill in all fields.');
  //     return false;
  //   }

  //   if (_passwordController.text != _confirmPasswordController.text) {
  //     setState(() => _errorText = 'Passwords do not match.');
  //     return false;
  //   }

  //   if (_passwordController.text.length < 8) {
  //     setState(() => _errorText = 'Password must be at least 8 characters.');
  //     return false;
  //   }

  //   setState(() => _errorText = '');
  //   return true;
  // }

  Future<void> _submitNewPassword() async {
    var dio = Dio();

    try {
      var body = {
        'email': widget.email,
        'new_password': _passwordController.text,
        'confirm_password': _confirmPasswordController.text,
      };

      var response = await dio.post(ApiConstants.changePassword,
          options: Options(
            headers: {'Authorization': 'Bearer ${widget.JWT_TOKEN}'},
          ),
          data: body);

      if (response.statusCode == 200) {
        showToast(message: 'Password changed successfully!');
        Future.delayed(
            const Duration(seconds: 3), () => Navigator.pop(context));
      } else {
        final responseData = response.data;
        String errorMessage;
        switch (response.statusCode) {
          case 400:
            errorMessage =
                responseData['message'] ?? 'Invalid request. Check your input.';
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
        setState(() => _errorText = errorMessage);
      }
    } catch (e) {
      print('Error: $e');
      setState(() => _errorText = 'Network error. Check your connection.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          image: DecorationImage(
              image: AssetImage(Assets.assetsImagesBg), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.05,
                      vertical: constraints.maxHeight * 0.02,
                    ),
                    child: _buildCard(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard() {
    return CustomCard(
        widget: Column(
      children: [
        Text(
          AppStrings.appName.toUpperCase(),
          style: CustomTextStyles.appTitleText(context),
        ),
        SizedBox(height: 12.h),
        Text(
          AppStrings.msgChangePassword,
          style: CustomTextStyles.msgAuthTitleText(context),
        ),
        SizedBox(height: 15.h),
        Text(
          widget.email,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15.h),
        PrimaryTextfield(
          controller: _passwordController,
          isPassword: _isPasswordHidden,
          labelText: AppStrings.lblPassword,
          prefixIcon: Icon(FeatherIcons.lock,
              size: 20,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.13)),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordHidden ? FeatherIcons.eyeOff : FeatherIcons.eye,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
              size: 18.spMax,
            ),
            onPressed: () {
              setState(() {
                _isPasswordHidden = !_isPasswordHidden;
              });
            },
          ),
        ),
        SizedBox(height: 5.h),
        PrimaryTextfield(
          controller: _confirmPasswordController,
          isPassword: _isConfirmPasswordHidden,
          labelText: AppStrings.lblConfirmPassword,
          prefixIcon: Icon(FeatherIcons.lock,
              size: 20,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.13)),
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordHidden ? FeatherIcons.eyeOff : FeatherIcons.eye,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
              size: 18.spMax,
            ),
            onPressed: () {
              setState(
                  () => _isConfirmPasswordHidden = !_isConfirmPasswordHidden);
            },
          ),
        ),
        if (_errorText.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 3.h),
            child: Text(_errorText, style: CustomTextStyles.msgErrorText),
          ),
        SizedBox(height: 10.h),
        AuthButton(
            title: AppStrings.lblDone,
            onPressed: _isLoading ? null : _submitNewPassword,
            isLoading: _isLoading),
        SizedBox(height: 5.h),
      ],
    ));
  }
}
