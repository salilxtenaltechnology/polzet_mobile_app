// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class Story extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StoryState();
  }
}

class StoryState extends State<Story> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 100.h,
                          width: 90.w,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color:Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.transparent, width: 1.5)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Text(
                      'James',
                     style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),
                      ],
                    ),
                    Positioned(
                      right: 12, 
                      bottom: 30,
                      child: Container(
                        height: 20, 
                        width: 20, 
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(3), 
                        ),
                        child: Center(child: Icon(Icons.add,size: 17,color: Colors.white,)),
                      ),
                    ),
                    
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 100.h,
                      width: 90.w,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.5), width: 1.3)),
                      child: Container(
                        decoration: BoxDecoration(
                          color:Theme.of(context).colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'James',
                     style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 100.h,
                      width: 90.w,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color:Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.5), width: 1.3)),
                      child: Container(
                        decoration: BoxDecoration(
                         color: Theme.of(context).colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'James',
                     style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      height: 100.h,
                      width: 90.w,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color:Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.5), width: 1.3)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'James',
                     style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 100.h,
                      width: 90.w,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color:Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.5), width: 1.3)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'James',
                     style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 100.h,
                      width: 90.w,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color:Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.5), width: 1.3)),
                      child: Container(
                        decoration: BoxDecoration(
                         color: Theme.of(context).colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'James',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
