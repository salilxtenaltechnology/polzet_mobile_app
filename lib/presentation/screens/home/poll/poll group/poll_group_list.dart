// ignore_for_file: deprecated_member_use

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polzet_mobile_app/mixins/utility_mixins.dart';
import 'package:polzet_mobile_app/presentation/common%20widgets/custom_card.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../../common widgets/custom_text_styles.dart';
import '../../../../common widgets/diolog/custom_diolog.dart';
import 'group_details.dart';

class PollGroupList extends StatefulWidget {
  const PollGroupList({super.key});

  @override
  State<PollGroupList> createState() => _PollGroupListState();
}

class _PollGroupListState extends State<PollGroupList> with UtilityMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
         toolbarHeight: 25.h,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        title: Text(AppLocalizations.of(context)!.pollgroup,
            style: CustomTextStyles.appBarTitleText(context)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
        actions: [
          Container(
            width: 92.w,
            height: 23.h,
            margin: EdgeInsets.only(right: 10.w, top: 3.h),
            decoration: BoxDecoration(
              color: Color(0XFFC8FEC5),
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Center(
              child: Text(AppLocalizations.of(context)!.groupcreate,
                  style: TextStyle(
                      color: Color(0XFF0A9C03),
                      fontSize: 10.3.sp,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10.h),
              height: 34.6.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(17.r),
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
                  hintText: AppLocalizations.of(context)!.searchgroup,
                  hintStyle: CustomTextStyles.lblPrimaryHintText(context),
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    FeatherIcons.search,
                    size: 17.spMax,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(17.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(17.r)),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () {
                navigationPush(context, GroupDetails());
              },
              child: CustomCard(
                  widget: Row(
                children: [
                  Image.asset(Assets.assetsImagesIcFood,
                      height: 30.h, width: 30.w),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Food',
                          style: CustomTextStyles.lblContentText(context)),
                      Text('40 Member',
                          style: CustomTextStyles.lblSecondryText(context)),
                    ],
                  ),
                  Spacer(),
                  Container(
                    height: 17.h,
                    width: 17.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '3',
                        style: TextStyle(fontSize: 10.sp, color: Colors.white),
                      ),
                    ),
                  ),
                  // Icon(Icons.more_vert, size: 20.sp),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    iconSize: 20.spMax,
                    icon: Icon(Icons.more_vert, size: 20.spMax),
                    onSelected: (String value) {
                      // Handle the selected value
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                          value: 'exit',
                          child: Text('Exit group'),
                          onTap: () {
                            showExitGroupDiolog(context, () {
                              Navigator.of(context).pop();
                            });
                          },
                          ),
                      PopupMenuItem(value: 'info', child: Text('Group Info')),
                      PopupMenuItem(
                          value: 'unread',
                          child: Text('Mark as unread')),
                      PopupMenuItem(
                          value: 'favorites', child: Text('Add to Favorites')),
                    ],
                  ),
                ],
              )),
            ),
            // SizedBox(height: 12.h),
            // CustomCard(
            //     widget: Row(
            //   children: [
            //     Image.asset(Assets.assetsImagesIcFood,
            //         height: 30.h, width: 30.w),
            //     SizedBox(width: 10.w),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text('Food',
            //             style: CustomTextStyles.lblContentText(context)),
            //         Text('40 Member',
            //             style: CustomTextStyles.lblSecondryText(context)),
            //       ],
            //     ),
            //     Spacer(),
            //     Container(
            //       height: 17.h,
            //       width: 17.w,
            //       decoration: const BoxDecoration(
            //         color: AppColors.primaryColor,
            //         shape: BoxShape.circle,
            //       ),
            //       child: Center(
            //         child: Text(
            //           '3',
            //           style: TextStyle(fontSize: 10.sp, color: Colors.white),
            //         ),
            //       ),
            //     ),
            //     Icon(Icons.more_vert, size: 20.sp),
            //   ],
            // ))
          ],
        ),
      ),
    );
  }
}
