// ignore_for_file: deprecated_member_use

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import 'custom_text_styles.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) onChanged;

  const SearchAppBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 12).w,
      child: Container(
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(right: 12.w, left: 12.w, top: 10.h),
              hintText: 'Search',
              hintStyle: CustomTextStyles.lblPrimaryHintText(context),
              border: InputBorder.none,
              suffixIcon: Icon(
                FeatherIcons.search,
                size: 17.spMax,
                color: Theme.of(context).colorScheme.onBackground,
              ),
             enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(15.r)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.primaryColor, width: 0.7),
                        borderRadius: BorderRadius.circular(15.r)),
             ),
          style: CustomTextStyles.lblPrimaryText(context),
        ),
      ),
    ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
