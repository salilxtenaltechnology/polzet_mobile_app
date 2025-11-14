// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polzet_mobile_app/presentation/common%20widgets/custom_card.dart';

class PostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PostPageState();
  }
}

class PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'FOR POLL OPTION',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        actions: [Icon(Icons.add_to_photos_outlined), SizedBox(width: 10.w)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            CustomCard(
                widget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: Color(0XFFEEEEEE), width: 1)),
                  child: Text(
                    'Answer 1',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: Color(0XFFEEEEEE), width: 1)),
                  child: Text('Answer 2',style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400),),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: Color(0XFFEEEEEE), width: 1)),
                  child: Text('Answer 3',style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400),),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: Color(0XFFEEEEEE), width: 1)),
                  child: Text('Answer 4',style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400),),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
