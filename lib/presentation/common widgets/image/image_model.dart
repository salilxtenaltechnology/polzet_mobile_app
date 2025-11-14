// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ImageModel extends StatelessWidget {
  ImageModel({super.key, required this.image});

  String image;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            image: DecorationImage(image: AssetImage(image))),
      ),
    );
  }
}
