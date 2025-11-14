// ignore_for_file: deprecated_member_use

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polzet_mobile_app/presentation/common%20widgets/button/back_button.dart';
import 'package:polzet_mobile_app/presentation/common%20widgets/button/primary_button.dart';
import 'package:polzet_mobile_app/presentation/common%20widgets/custom_text_styles.dart';
import 'package:polzet_mobile_app/presentation/common%20widgets/text%20field/secondry_textfield.dart';

import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_strings.dart';
import '../../common widgets/custom_card.dart';

class CreateGroup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateGroupState();
  }
}

class CreateGroupState extends State<CreateGroup> {
  final _groupNmaeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: PrimaryBackButton(),
        title: Text(
          'Create Group',
         style: CustomTextStyles.appBarTitleText(context)
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12).w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name Group',
              style: CustomTextStyles.lblPrimaryText(context)
            ),
            SizedBox(height: 5.h),
            SecondryTextfield(controller: _groupNmaeController, hintText: 'Enter group name'),
            SizedBox(height: 15.h),
            Text(
              'Members',
             style: CustomTextStyles.lblPrimaryText(context)
            ),
            SizedBox(height: 5.h),
            Container(
              height: 35.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color:Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(7.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FeatherIcons.plus,
                    size: 20.sp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    AppStrings.lblGetStarted,
                    style: CustomTextStyles.btnSecondryText(context)
                  )
                ],
              ),
            ),
            SizedBox(height: 15.h),
            CustomCard(
                widget: Row(
              children: [
                Image.asset(Assets.assetsImagesIcUser,
                    height: 30.h, width: 30.w),
                SizedBox(width: 12.w),
                Text(
                  'User Name',
                  style: CustomTextStyles.lblSecondryText(context)
                ),
                Spacer(),
                Icon(
                  Icons.close,
                  size: 20.spMax,
                  color: Colors.red,
                ),
              ],
            ))
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 50.h,
        child: PrimaryButton(title: AppStrings.lblGetStarted, onPressed: (){}, isLoading: false)
      ),
    );
  }
}
