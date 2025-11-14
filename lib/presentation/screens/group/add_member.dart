// ignore_for_file: deprecated_member_use

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../mixins/utility_mixins.dart';
import '../../common widgets/custom_card.dart';
import '../../common widgets/custom_text_styles.dart';
import 'create_group.dart';


class AddMember extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddMemberState();
  }
}

class AddMemberState extends State<AddMember> with UtilityMixin {
  bool _isChecked = false;
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
        title: Text(
          'Add members to group',
          style: CustomTextStyles.appBarTitleText(context),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10.h),
              height: 36.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(16),
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            CustomCard(
                widget: Row(
              children: [
                Image.asset(Assets.assetsImagesIcUser,
                    height: 30.h, width: 30.w),
                SizedBox(width: 12.w),
                Text(
                  'User Name',
                  style:  CustomTextStyles.lblSecondryText(context)
                ),
                Spacer(),
                SizedBox(
                  width: 22.w,
                  height: 22.h,
                  child: Checkbox(
                    side: BorderSide(
                      color: Color(0XFFD9D9D9),
                      width: 1.1,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    value: _isChecked,
                    checkColor: Colors.white,
                    activeColor: Color(0xFF9B3046),
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 50.h,
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: 15.w, right: 0, bottom: 10.h, top: 5.h),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(50.r)),
                child: Center(
                    child:
                        Text('Cancel', style: CustomTextStyles.btnPrimaryText)),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  navigationPush(context, CreateGroup());
                },
                child: Container(
                  margin: EdgeInsets.only(
                      left: 0, right: 15.w, bottom: 10.h, top: 5.h),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(50.r)),
                  child: Center(
                      child:
                          Text('Add', style: CustomTextStyles.btnPrimaryText)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
