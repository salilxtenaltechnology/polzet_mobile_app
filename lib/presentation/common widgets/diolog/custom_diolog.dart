// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_images.dart';
import 'delete_account.dart';
import 'delete_post_diolog.dart';
import 'diolog_animation.dart';
import 'exit_group.dart';
import 'image_upload_diolog.dart';
import 'logout_dialog.dart';
import 'notifications_diolog.dart';
import 'user_info_diolog.dart';

// user info diolog
showUserInfoDiolog(BuildContext context, VoidCallback onTap) {
  diologanimation(
      context,
      UserInfoDiolog(
        onPressed: onTap,
      ));
}

// user delete post diolog
showUserDeletePostDiolog(BuildContext context, VoidCallback onTap) {
  diologanimation(
      context,
      DeletePostDiolog(
        onPressed: onTap,
      ));
}

// logout diolog
showLogoutDiolog(BuildContext context, VoidCallback onTap) {
  diologanimation(
      context,
      LogoutDialog(
        onPressed: onTap,
      ));
}

// delete account diolog
showDeleteAccountDiolog(BuildContext context, VoidCallback onTap) {
  diologanimation(
      context,
      DeleteAccountDioloig(
        onPressed: onTap,
      ));
}

// loading diolog
void showLoadingDialog(BuildContext context) {
  diologanimation(
    context,
    Container(
      width: 55.w,
      height: 55.h,
      color: Colors.transparent,
      child: Center(
        child: Lottie.asset(Assets.assetsImagesProgressIndicator, repeat: true),
      ),
    ),
  );

  void showNoInternetDialog(BuildContext context) {
    diologanimation(
        context,
        Container(
          width: 315,
          padding: EdgeInsets.fromLTRB(15.w, 13.h, 15.w, 13.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 30, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "No Internet Connection",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 8),
              Text(
                "Please check your network settings.",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ));
  }
}

// exit group diolog
showExitGroupDiolog(BuildContext context, VoidCallback onTap) {
  diologanimation(
      context,
      ExitGroupDiolog(
        onPressed: onTap,
      ));
}

// user profile and cover image upload
showImageUploadDiolog(BuildContext context,
    Function(String type, dynamic image) onImageSelected) {
  diologanimation(
      context,
      ImageUploadDiolog(
        onImageSelected: onImageSelected,
      ));
}

// user delete post diolog
showNotificationTimerDiolog(BuildContext context, VoidCallback onTap) {
  diologanimation(
      context,
      NotificationsDiolog(
        onPressed: onTap,
      ));
}
