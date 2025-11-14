// ignore_for_file: deprecated_member_use, must_be_immutable, unused_local_variable, unused_element, unused_field
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/biometric/biometric_service.dart';
import '../../../mixins/utility_mixins.dart';
import '../auth/login/login_import.dart';
import '../home/home_imports.dart';

class SplashScreen extends StatefulWidget {
  bool? isLogged;
  bool? requiresBiometric;
  
  SplashScreen({
    Key? key, 
    required this.isLogged,
    this.requiresBiometric = false,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin, UtilityMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<Offset> _textAnimation;
  
  bool _isAuthenticating = false;
  bool _authenticationCompleted = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Logo animation: small to big
    _logoAnimation = Tween<double>(begin: 0.02, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.7, curve: Curves.easeInCubic),
      ),
    );

    // Text animation: right to left
    _textAnimation = Tween<Offset>(
      begin: const Offset(2.2, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.7, 1.0, curve: Curves.decelerate),
      ),
    );

    // Start animation
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_authenticationCompleted) {
        _handlePostAnimation();
      }
    });
  }

  void _handlePostAnimation() async {
    if (widget.requiresBiometric == true && !_isAuthenticating) {
      await _performBiometricAuthentication();
    } else {
      _navigateToNextScreen();
    }
  }

  Future<void> _performBiometricAuthentication() async {
    if (_isAuthenticating) return;
    
    setState(() {
      _isAuthenticating = true;
    });

    try {
      // Check if biometric is available
      final bool isBiometricAvailable = await BiometricService.isBiometricAvailable();
      
      if (!isBiometricAvailable) {
        // If biometric is not available, proceed to home
        _authenticationCompleted = true;
        _navigateToNextScreen();
        return;
      }

      // Get appropriate biometric message
      final String biometricMessage = await BiometricService.getBiometricMessage();
      
      // Perform biometric authentication
      final bool isAuthenticated = await BiometricService.authenticateWithBiometrics(
        reason: biometricMessage,
        useErrorDialogs: true,
        stickyAuth: true,
      );

      _authenticationCompleted = true;

      if (isAuthenticated) {
        // Authentication successful, proceed to home
        redirectToHomeScreen();
      } else {
        // Authentication failed, redirect to login
        redirectToLoginScreen();
      }
    } catch (e) {
      print('Biometric authentication error: $e');
      _authenticationCompleted = true;
      
      // On error, you might want to proceed to home or login based on your app's logic
      // For now, redirecting to login as a safe fallback
      redirectToLoginScreen();
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(milliseconds: 400), () {
      if (widget.isLogged == true) {
        redirectToHomeScreen();
      } else {
        redirectToLoginScreen();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoAnimation.value,
                      child: Image.asset(
                        Assets.assetsImagesIcSplash,
                        width: 38.w,
                        height: 38.h,
                      ),
                    );
                  },
                ),
                SizedBox(width: 7.w),
                SlideTransition(
                  position: _textAnimation,
                  child: Text(
                    AppStrings.appName.toUpperCase(),
                    style: GoogleFonts.yesevaOne(
                      color: AppColors.primaryColor,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            
            // Show loading indicator when authenticating
            if (_isAuthenticating) ...[
              SizedBox(height: 40.h),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
              SizedBox(height: 16.h),
              Text(
                'Authenticating...',
                style: GoogleFonts.poppins(
                  color: AppColors.primaryColor,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void redirectToLoginScreen() {
    clearStackAndAddScreen(context, LoginScreen());
  }

  void redirectToHomeScreen() {
    clearStackAndAddScreen(context, HomeScreen());
  }
}