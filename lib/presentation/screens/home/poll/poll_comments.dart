// ignore_for_file: deprecated_member_use

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_images.dart';
import '../../../common widgets/button/back_button.dart';
import '../../../common widgets/custom_text_styles.dart';

class PollComments extends StatefulWidget {
  const PollComments({super.key});

  @override
  State<PollComments> createState() => _PollCommentsState();
}

class _PollCommentsState extends State<PollComments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: PrimaryBackButton(),
        title:
            Text('Commnets', style: CustomTextStyles.appBarTitleText(context)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '12 Comments'.toUpperCase(),
                style: CustomTextStyles.lblPrimaryText(context),
              ),
              Divider(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
                height: 12.h,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                titleAlignment: ListTileTitleAlignment.titleHeight,
                leading: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: Colors.grey[700],
                  backgroundImage: AssetImage(Assets.assetsImagesPeople3),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '@JeanetteGottlieb',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.msgAuthTitleText(context),
                    ),
                    Text(
                      '1 hours ago',
                      style: TextStyle(
                          fontSize: 10.2.sp,
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.45)),
                    ),
                  ],
                ),
                subtitle: Text(
                  'I love how the light hits it! It really brings out the texture of the petals. Such a warm feeling.',
                  style: CustomTextStyles.lblSecondryText(context),
                ),
              ),
              Divider(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
                height: 8.h,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                //titleAlignment: ListTileTitleAlignment.center,
                leading: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: Colors.grey[700],
                  backgroundImage: AssetImage(Assets.assetsImagesPeople2),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '@AngelaMayer',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.msgAuthTitleText(context),
                    ),
                    Text(
                      '3 hours ago',
                      style: TextStyle(
                          fontSize: 10.2.sp,
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.45)),
                    ),
                  ],
                ),
                subtitle: Text(
                  'Wow, beautiful! Great capture!',
                  style: CustomTextStyles.lblSecondryText(context),
                ),
              ),
              Container(
                height: 37.h,
                width: double.infinity,
                margin: EdgeInsets.all(12).w,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type message here...',
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            color: Color(0XFF8593A8),
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      FeatherIcons.smile,
                      size: 20.spMax,
                      color: Color(0XFF8593A8),
                    ),
                    SizedBox(width: 7.w),
                    Icon(
                      FeatherIcons.send,
                      size: 20.spMax,
                      color: Color(0XFF8593A8),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
