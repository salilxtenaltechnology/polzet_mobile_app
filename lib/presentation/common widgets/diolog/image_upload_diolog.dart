// ignore_for_file: deprecated_member_use, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../custom_text_styles.dart';

class ImageUploadDiolog extends StatelessWidget {
  ImageUploadDiolog({required this.onImageSelected});

  final Function(String type, dynamic image) onImageSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315,
      padding: EdgeInsets.fromLTRB(15.w, 13.h, 15.w, 13.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _label(context, 'Profile Photo', () {
            Navigator.pop(context);
          }),
          _primaryDivider(context),
          _label(context, 'Cover Photo', () {
            Navigator.pop(context);
          }),
          _primaryDivider(context),
          _label(context, 'Cancel', () {
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget _label(BuildContext context, String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: CustomTextStyles.lblPrimaryText(context),
      ),
    );
  }

  Widget _primaryDivider(BuildContext context) {
    return Divider(
      height: 18.h,
      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
    );
  }
}
