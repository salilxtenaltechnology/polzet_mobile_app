// ignore_for_file: deprecated_member_use

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_images.dart';
import '../../../../common widgets/button/back_button.dart';
import '../../../../common widgets/custom_card.dart';
import '../../../../common widgets/custom_text_styles.dart';
import '../../../../common widgets/image/image_model.dart';

class PollResults extends StatefulWidget {
  const PollResults({super.key});

  @override
  State<PollResults> createState() => _PollResultsState();
}

class _PollResultsState extends State<PollResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: PrimaryBackButton(),
          centerTitle: true,
          title: Text('Active Polls',
              style: CustomTextStyles.appBarTitleText(context)),
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Theme.of(context).colorScheme.background,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          child: Column(
            children: [
              CustomCard(
                widget: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Question',
                            style: CustomTextStyles.lblPrimaryText(context)),
                        Icon(FeatherIcons.thumbsUp,
                            size: 20,
                            color: Theme.of(context).colorScheme.onBackground)
                      ],
                    ),
                    SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImageModel(image: Assets.assetsImagesPeople1),
                     
                      ImageModel(image: Assets.assetsImagesPeople2),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImageModel(image: Assets.assetsImagesPeople3),
                      ImageModel(image: Assets.assetsImagesPeople4),
                    ],
                  ),
                  SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FeatherIcons.eye,
                                  size: 18.spMax, color: Color(0xFFAAAAAA)),
                              SizedBox(width: 5.w),
                              Text('3000',
                                  style: TextStyle(
                                      color: Color(0xFFAAAAAA),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FeatherIcons.messageSquare,
                                  size: 18.spMax, color: Color(0xFFAAAAAA)),
                              SizedBox(width: 5.w),
                              Text('850',
                                  style: TextStyle(
                                      color: Color(0xFFAAAAAA),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FeatherIcons.share2,
                                  size: 18.spMax, color: Color(0xFFAAAAAA)),
                              SizedBox(width: 5.w),
                              Text('90',
                                  style: TextStyle(
                                      color: Color(0xFFAAAAAA),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Result Polls',
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
                children: [
                  Image.asset(Assets.assetsImagesAvtar1,
                      height: 30.h, width: 30.w),
                  SizedBox(width: 12.w),
                  Text('User Name',
                      style: CustomTextStyles.lblPrimaryText(context)),
                  Spacer(),
                  Text(
                    'Voted',
                    style: TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: 10.w),
                  Image.asset(Assets.assetsImagesPeople1,
                      height: 30.h, width: 30.w)
                ],
              )),
              SizedBox(height: 15.h),
              CustomCard(
                  widget: Row(
                children: [
                  Image.asset(Assets.assetsImagesAvtar2,
                      height: 30.h, width: 30.w),
                  SizedBox(width: 12.w),
                  Text('User Name',
                      style: CustomTextStyles.lblPrimaryText(context)),
                  Spacer(),
                  Text(
                    'Voted',
                    style: TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: 10.w),
                  Image.asset(Assets.assetsImagesPeople3,
                      height: 30.h, width: 30.w)
                ],
              ))
            ],
          ),
        ));
  }
}
