// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../data/pin/pin_service.dart';

class VerifyPinScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function(bool)? onPinVerified;
  final bool canGoBack;

  const VerifyPinScreen({
    Key? key,
    this.title = 'Enter PIN',
    this.subtitle = 'Please enter your PIN',
    this.onPinVerified,
    this.canGoBack = false,
  }) : super(key: key);

  @override
  _VerifyPinScreenState createState() => _VerifyPinScreenState();
}

class _VerifyPinScreenState extends State<VerifyPinScreen>
    with TickerProviderStateMixin {
  List<String> _enteredPin = [];
  int _pinLength = 4; // Default PIN length
  bool _isVerifying = false;
  int _attemptCount = 0;
  final int _maxAttempts = 5;
  bool _isBlocked = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _loadPinLength();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _loadPinLength() async {
    try {
      // Get PIN status to determine length
      final pinStatus = await PinService.getPinStatus();
      if (pinStatus.isPinSet) {
        setState(() {
          _pinLength = _pinLength; // Now this should work
        });
      }
    } catch (e) {
      // Handle error, use default length
      setState(() {
        _pinLength = 4;
      });
    }
  }

  void _onNumberPressed(String number) {
    if (_isBlocked || _isVerifying) return;

    setState(() {
      if (_enteredPin.length < _pinLength) {
        _enteredPin.add(number);

        // Haptic feedback
        HapticFeedback.lightImpact();

        // Auto verify when PIN is complete
        if (_enteredPin.length == _pinLength) {
          _verifyPin();
        }
      }
    });
  }

  void _onDeletePressed() {
    if (_isBlocked || _isVerifying || _enteredPin.isEmpty) return;

    setState(() {
      _enteredPin.removeLast();
    });

    HapticFeedback.selectionClick();
  }

  Future<void> _verifyPin() async {
    if (_isVerifying) return;

    setState(() {
      _isVerifying = true;
    });

    try {
      final enteredPinString = _enteredPin.join();
      final isValid = await PinService.verifyPin(enteredPinString);

      if (isValid) {
        // PIN is correct
        HapticFeedback.heavyImpact(); // Changed from notificationFeedback

        if (widget.onPinVerified != null) {
          widget.onPinVerified!(true);
        }

        // Navigate back with success
        Navigator.of(context).pop(true);
      } else {
        // PIN is incorrect
        _handleIncorrectPin();
      }
    } catch (e) {
      _showErrorSnackBar('Error verifying PIN: $e');
      _clearPin();
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  void _handleIncorrectPin() {
    HapticFeedback.vibrate(); // Changed from notificationFeedback

    setState(() {
      _attemptCount++;

      if (_attemptCount >= _maxAttempts) {
        _isBlocked = true;
      }
    });

    // Shake animation for incorrect PIN
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });

    // Clear the entered PIN after a delay
    Future.delayed(Duration(milliseconds: 500), () {
      _clearPin();
    });

    if (_isBlocked) {
      _showBlockedDialog();
    } else {
      _showErrorSnackBar(
        'Incorrect PIN. ${_maxAttempts - _attemptCount} attempts remaining.',
      );
    }
  }

  void _clearPin() {
    setState(() {
      _enteredPin.clear();
    });
  }

  void _showBlockedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Too Many Attempts'),
          content: Text(
            'You have exceeded the maximum number of PIN attempts. Please try again later or contact support.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(false); // Close PIN screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: widget.canGoBack
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Icon(
                Icons.lock_outline,
                size: 50.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 20.h),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 17.5.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: 15.5.sp,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 35.h),
              // PIN Input Display
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pinLength, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _enteredPin.length > index
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),

              SizedBox(height: 20.h),

              // Error message or loading
              if (_isVerifying)
                CircularProgressIndicator()
              else if (_isBlocked)
                Text(
                  'Too many incorrect attempts',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.sp,
                  ),
                )
              else if (_attemptCount > 0)
                Text(
                  '${_maxAttempts - _attemptCount} attempts remaining',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14.sp,
                  ),
                ),
              SizedBox(height: 30.h),
              // Number Pad
              Expanded(
                child: _buildNumberPad(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: false,
      childAspectRatio: 1.6,
      mainAxisSpacing: 10.h,
      crossAxisSpacing: 10.w,
      children: [
        // Numbers 1-9
        ...List.generate(9, (index) {
          final number = (index + 1).toString();
          return _buildNumberButton(number);
        }),

        // Delete button
        _buildDeleteButton(),
        // Number 0
        _buildNumberButton('0'),
        // Empty all numbers
        _buildClearAllNumberButton(),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _onNumberPressed(number),
      child: Container(
        height: 60.h,
        width: 60.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClearAllNumberButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 60.h,
        width: 60.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
            size: 22.spMax,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _onDeletePressed,
      child: Container(
        height: 60.h,
        width: 60.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 22.spMax,
          ),
        ),
      ),
    );
  }
}
