// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_strings.dart';
import '../../common widgets/custom_text_styles.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off,
                size: 50.spMax, color: Color(0XFF999999).withOpacity(0.6)),
            SizedBox(height: 15.h),
            Text(
              AppStrings.lblNoInternet,
              style: CustomTextStyles.lblNoInternetText(context),
            ),
            SizedBox(height: 7.h),
            Text(
              AppStrings.msgNoInternet,
              style: CustomTextStyles.msgNoInternetText(context),
            ),
          ],
        ),
      ),
    );
  }
}
