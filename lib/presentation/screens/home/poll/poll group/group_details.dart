// ignore_for_file: deprecated_member_use

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polzet_mobile_app/core/constants/app_images.dart';
import 'package:polzet_mobile_app/presentation/common%20widgets/custom_text_styles.dart';
import 'package:polzet_mobile_app/presentation/screens/home/poll/poll%20group/member/all_members.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../../../mixins/utility_mixins.dart';
import '../../../../common widgets/diolog/custom_diolog.dart';

class GroupDetails extends StatefulWidget {
  const GroupDetails({super.key});

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> with UtilityMixin {
  bool _isMuteNotification = false;
  bool _isProtectedChat = false;
  bool _isHideChat = false;
  bool _isHideChatHistory = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
        actions: [
          Icon(FeatherIcons.video, size: 20.sp),
          SizedBox(width: 15.w),
          Icon(FeatherIcons.phone, size: 18.sp),
          SizedBox(width: 15.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            SizedBox(
              height: 100.h,
              width: 100.w,
              child: Stack(
                children: [
                 
                  Container(
                    padding: EdgeInsets.all(15.w),
                    margin: EdgeInsets.only(bottom: 10.h),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.1),
                        width: 1.2.w,
                      ),
                    ),
                    child: Center(
                        child: Image.asset(
                      Assets.assetsImagesIcFood,
                    )),
                  ),
                   Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 25.h,
                      width: 25,
                      margin: EdgeInsets.only(right: 5.w),
                      decoration: BoxDecoration(
                        color: Color(0XFF40C4FF),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child:  Icon(Icons.edit,
                    color: Colors.white,
                    size: 13.spMax),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Food',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 10.w),
                Icon(FeatherIcons.edit2,
                    color: Theme.of(context).colorScheme.onBackground,
                    size: 16.spMax),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              '40 Members',
              style: CustomTextStyles.lblPrimaryText(context),
            ),
            GestureDetector(
              onTap: () {
                navigationPush(context, AllMembers());
              },
              child: Container(
                height: 38.h,
                width: double.infinity,
                padding: EdgeInsets.all(5.w),
                margin: EdgeInsets.only(top: 15.h, bottom: 10.h),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16.r)),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SizedBox(
                          width: 60.w,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.w,
                                ),
                                image: const DecorationImage(
                                  image: AssetImage(Assets.assetsImagesPeople1),
                                  fit: BoxFit.contain,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 40.h,
                            width: 40.w,
                            margin: EdgeInsets.only(left: 8.w),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.w,
                              ),
                              image: const DecorationImage(
                                image: AssetImage(Assets.assetsImagesPeople2),
                                fit: BoxFit.contain,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 40.h,
                            width: 40.w,
                            margin: EdgeInsets.only(left: 16.w),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.w,
                              ),
                              image: const DecorationImage(
                                image: AssetImage(Assets.assetsImagesPeople3),
                                fit: BoxFit.contain,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text( AppLocalizations.of(context)!.seeallmembers,
                        style: CustomTextStyles.btnPrimaryText),
                    Spacer(),
                    Icon(
                      FeatherIcons.chevronRight,
                      color: Colors.white,
                      size: 20.spMax,
                    )
                  ],
                ),
              ),
            ),
            Divider(
                thickness: 1,
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.1)),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Row(
                children: [
                  Icon(FeatherIcons.image, size: 20.spMax),
                  SizedBox(width: 8.w),
                  Text('Media, Links & Documents',
                      style: CustomTextStyles.lblContentText(context)),
                  Spacer(),
                  Text('155', style: CustomTextStyles.lblContentText(context)),
                  SizedBox(width: 10.w),
                  Icon(
                    FeatherIcons.chevronRight,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                    size: 20.spMax,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                children: [
                  Icon(FeatherIcons.volume2, size: 20.spMax),
                  SizedBox(width: 8.w),
                  Text('Mute Notification',
                      style: CustomTextStyles.lblContentText(context)),
                  Spacer(),
                  Container(
                    color: Colors.white,
                    width: 35.w,
                    height: 20.h,
                    child: Transform.scale(
                      scale: 0.75,
                      child: CupertinoSwitch(
                          activeTrackColor: AppColors.primaryColor,
                          value: _isMuteNotification,
                          onChanged: (value) =>
                              setState(() => _isMuteNotification = value)),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                children: [
                  Icon(FeatherIcons.bell, size: 19.spMax),
                  SizedBox(width: 8.w),
                  Text('Custom Notification',
                      style: CustomTextStyles.lblContentText(context)),
                  Spacer(),
                  Icon(
                    FeatherIcons.chevronRight,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                    size: 20.spMax,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                children: [
                  Icon(FeatherIcons.shield, size: 19.spMax),
                  SizedBox(width: 8.w),
                  Text('Protected Chat',
                      style: CustomTextStyles.lblContentText(context)),
                  Spacer(),
                  SizedBox(
                    width: 30.w,
                    height: 20.h,
                    child: Transform.scale(
                      scale: 0.75,
                      child: CupertinoSwitch(
                          activeTrackColor: AppColors.primaryColor,
                          value: _isProtectedChat,
                          onChanged: (value) =>
                              setState(() => _isProtectedChat = value)),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                children: [
                  Icon(FeatherIcons.eye, size: 19.spMax),
                  SizedBox(width: 8.w),
                  Text('Hide Chat',
                      style: CustomTextStyles.lblContentText(context)),
                  Spacer(),
                  SizedBox(
                    width: 30.w,
                    height: 20.h,
                    child: Transform.scale(
                      scale: 0.75,
                      child: CupertinoSwitch(
                          activeTrackColor: AppColors.primaryColor,
                          value: _isHideChat,
                          onChanged: (value) =>
                              setState(() => _isHideChat = value)),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                children: [
                  Icon(FeatherIcons.eye, size: 19.spMax),
                  SizedBox(width: 8.w),
                  Text('Hide Chat History',
                      style: CustomTextStyles.lblContentText(context)),
                  Spacer(),
                  SizedBox(
                    width: 30.w,
                    height: 20.h,
                    child: Transform.scale(
                      scale: 0.75,
                      child: CupertinoSwitch(
                          activeTrackColor: AppColors.primaryColor,
                          value: _isHideChatHistory,
                          onChanged: (value) =>
                              setState(() => _isHideChatHistory = value)),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                children: [
                  Icon(Icons.color_lens_outlined, size: 19.spMax),
                  SizedBox(width: 8.w),
                  Text('Custom Color Chat',
                      style: CustomTextStyles.lblContentText(context)),
                  Spacer(),
                  Container(
                    height: 18.h,
                    width: 20.w,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(5.r)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                children: [
                  Icon(FeatherIcons.image, size: 19.spMax),
                  SizedBox(width: 8.w),
                  Text('Custom Background Chat',
                      style: CustomTextStyles.lblContentText(context)),
                  Spacer(),
                  Container(
                    height: 18.h,
                    width: 20.w,
                    decoration: BoxDecoration(
                        color: Color(0XFFF0F0F3),
                        borderRadius: BorderRadius.circular(5.r)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    size: 19.spMax,
                    color: Color(0XFFF44336),
                  ),
                  SizedBox(width: 8.w),
                  Text('Report',
                      style: TextStyle(
                          color: Color(0XFFF44336),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: GestureDetector(
                onTap: () {
                  showExitGroupDiolog(context, () {
                    Navigator.pop(context);
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      size: 19.spMax,
                      color: Color(0XFFF44336),
                    ),
                    SizedBox(width: 8.w),
                    Text('Leave Group',
                        style: TextStyle(
                            color: Color(0XFFF44336),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
