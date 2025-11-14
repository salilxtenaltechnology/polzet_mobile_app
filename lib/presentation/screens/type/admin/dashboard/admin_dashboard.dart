// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../common widgets/custom_card.dart';
import '../../../../common widgets/custom_text_styles.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 40.h,
        leadingWidth: 200,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w, top: 10.h),
          child: Text('Welcome Back!',
              style: CustomTextStyles.appBarTitleText(context)),
        ),
        actions: [
          AppIcons(onTap: () {}, icon: Icons.menu),
          SizedBox(width: 5.w)
        ],
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          children: [
            CustomCard(
                widget: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('12 Active Polls',
                        style: CustomTextStyles.lblPrimaryText(context)),
                    Text('Show Details',
                        style: CustomTextStyles.msgAuthTitleText(context)),
                  ],
                ),
                GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.arrow_forward_ios,
                        size: 20.spMax, color: Color(0XFF999999))),
              ],
            )),
            SizedBox(height: 20.h),
            CustomCard(
                widget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Last  Viewed',
                    style: CustomTextStyles.msgAuthTitleText(context)),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(Assets.assetsImagesIcUser,
                        height: 27.h, width: 27.w),
                    Image.asset(Assets.assetsImagesIcUser,
                        height: 27.h, width: 27.w),
                    Image.asset(Assets.assetsImagesIcUser,
                        height: 27.h, width: 27.w),
                    Image.asset(Assets.assetsImagesIcUser,
                        height: 27.h, width: 27.w),
                    Image.asset(Assets.assetsImagesIcUser,
                        height: 27.h, width: 27.w),
                    Image.asset(Assets.assetsImagesIcUser,
                        height: 27.h, width: 27.w),
                    Image.asset(Assets.assetsImagesIcUser,
                        height: 27.h, width: 27.w),
                    Image.asset(Assets.assetsImagesIcUser,
                        height: 27.h, width: 27.w),
                  ],
                ),
              ],
            )), 
            SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('All Polls',
                      style: CustomTextStyles.lblPrimaryText(context)),
                  Text(
                    'See All',
                    style: CustomTextStyles.msgAuthTitleText(context)
                  ),
                ],
              ),
              SizedBox(height: 8.h),
            CustomCard(
                    widget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Poll - 1',
                        style: CustomTextStyles.lblPrimaryText(context)),
                    Text('1252',
                        style: CustomTextStyles.lblPrimaryText(context)),
                  ],
                )),
                SizedBox(height: 15.h),
                CustomCard(
                    widget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Poll - 2',
                        style: CustomTextStyles.lblPrimaryText(context)),
                    Text('1252',
                        style: CustomTextStyles.lblPrimaryText(context)),
                  ],
                )),
                SizedBox(height: 15.h),
                CustomCard(
                    widget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Poll - 3',
                        style: CustomTextStyles.lblPrimaryText(context)),
                    Text('1252',
                        style: CustomTextStyles.lblPrimaryText(context)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
