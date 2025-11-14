// ignore_for_file: deprecated_member_use

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polzet_mobile_app/presentation/common%20widgets/custom_card.dart';

import '../../../../../../core/constants/app_images.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../../common widgets/custom_text_styles.dart';

class AllMembers extends StatefulWidget {
  const AllMembers({super.key});

  @override
  State<AllMembers> createState() => _AllMembersState();
}

class _AllMembersState extends State<AllMembers> {
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
        title:
            Text(AppLocalizations.of(context)!.members, style: CustomTextStyles.appBarTitleText(context)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            Container(
                height: 38.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                    color: Color(0XFFF7EAED),
                    borderRadius: BorderRadius.circular(16.r)),
                child: Row(
                  children: [
                    Icon(FeatherIcons.user,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20.spMax), 
                  SizedBox(width: 12.w),
                  Text(AppLocalizations.of(context)!.addmember,style: CustomTextStyles.lblPrimaryText(context))
                  ],
                )),
            Container(
                height: 38.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                margin: EdgeInsets.only(top: 10.h),
                decoration: BoxDecoration(
                    color: Color(0XFFF7EAED),
                    borderRadius: BorderRadius.circular(16.r)),
                child: Row(
                  children: [
                    Icon(FeatherIcons.link2,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20.spMax), 
                  SizedBox(width: 12.w),
                  Text(AppLocalizations.of(context)!.invitetogroupvialink,style: CustomTextStyles.lblPrimaryText(context))
                  ],
                )),
              SizedBox(height: 10.h),
              CustomCard(widget: Row(
              children: [
                Image.asset(Assets.assetsImagesIcUser,
                    height: 27.h, width: 27.w),
                SizedBox(width: 12.w),
                Text(
                  'Members 1',
                  style: CustomTextStyles.lblPrimaryText(context)
                ),
               
              ],
            )), 
            SizedBox(height: 10.h),
              CustomCard(widget: Row(
              children: [
                Image.asset(Assets.assetsImagesIcUser,
                    height: 27.h, width: 27.w),
                SizedBox(width: 12.w),
                Text(
                  'Members 2',
                  style: CustomTextStyles.lblPrimaryText(context)
                ),
               
              ],
            ))
          ],
        ),
      ),
    );
  }
}
