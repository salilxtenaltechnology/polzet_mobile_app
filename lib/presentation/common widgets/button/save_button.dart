// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polzet_mobile_app/presentation/common%20widgets/custom_text_styles.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../loader.dart';

class SaveButton extends StatelessWidget {
  SaveButton({super.key, required this.onPressed, required this.isLoading});

  final VoidCallback? onPressed;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 33.h,
        width: 115.w,
        margin: EdgeInsets.only(top: 12.h),
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(50.r)),
        child: Center(
            child: isLoading
                ? Loader(color: Colors.white)
                : Text(AppStrings.lblSaveChanges,
                    style: CustomTextStyles.btnSaveChangesText)),
      ),
    );
  }
}
