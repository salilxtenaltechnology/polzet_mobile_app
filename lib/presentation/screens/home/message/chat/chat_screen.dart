// ignore_for_file: deprecated_member_use

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_images.dart';
import '../../../../common widgets/button/back_button.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          toolbarHeight: 60.h,
          automaticallyImplyLeading: false,
          leadingWidth: double.infinity,
          leading: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 12.w),
              PrimaryBackButton(),
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Color(0XFFEEEEEE),
                foregroundColor: Color(0XFFEEEEEE),
                backgroundImage: AssetImage(Assets.assetsImagesPeople3),
              ),
              SizedBox(width: 7.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Samuel Garry',
                     style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600)),
                  Text('Typing...',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 11.2.sp,
                          fontWeight: FontWeight.w300))
                ],
              )
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Theme.of(context).colorScheme.background,
          actions: [Icon(FeatherIcons.moreVertical,size: 18.spMax,), SizedBox(width: 3.w)],
        ),
        body: Column(
          children: [
            const Spacer(),
            Container(
              height: 37.h,
              width: double.infinity,
              margin: EdgeInsets.all(12).w,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color:Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type here...',
                        hintStyle: TextStyle(
                          color: Color(0XFF8593A8),
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    FeatherIcons.image,
                     size: 20.spMax,
                    color: Color(0XFF8593A8),
                  ),
                  SizedBox(width: 7.w),
                  Icon(
                    FeatherIcons.smile,
                    size: 20.spMax,
                    color: Color(0XFF8593A8),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
