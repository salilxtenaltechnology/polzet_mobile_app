// ignore_for_file: deprecated_member_use

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common widgets/button/back_button.dart';
import '../../../common widgets/custom_text_styles.dart';

class PollDesign extends StatefulWidget {
  const PollDesign({super.key});

  @override
  State<PollDesign> createState() => _PollDesignState();
}

class _PollDesignState extends State<PollDesign>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int selectedIndex = 0;

  final List<Map<String, dynamic>> designImages = [
    {
      'image': Assets.assetsImagesPollDesign1,
    },
    {
      'image': Assets.assetsImagesPollDesign2,
    },
    {
      'image': Assets.assetsImagesPollDesign3,
    },
    {
      'image': Assets.assetsImagesPollDesign4,
    },
    {
      'image': Assets.assetsImagesPollDesign5,
    },
    {
      'image': Assets.assetsImagesPollDesign6,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
         toolbarHeight: 25.h,
        leading: PrimaryBackButton(),
        title: Text(AppLocalizations.of(context)!.polldesign,
            style: CustomTextStyles.appBarTitleText(context)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            Container(
              height: 27.h,
              width: 200.w,
              margin: EdgeInsets.only(top: 5.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TabBar(
                labelPadding: EdgeInsets.zero,
                controller: _tabController,
                indicator: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8.r)),
                labelColor: Colors.white,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.description_outlined, size: 18.spMax),
                        SizedBox(width: 8.w),
                        Text(
                          AppStrings.lblThings,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FeatherIcons.image, size: 18.spMax),
                        SizedBox(width: 8.w),
                        Text(
                          AppStrings.lblPhotos,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Center(
                    child: Text(
                      'Things',
                      style: CustomTextStyles.lblPrimaryText(context),
                    ),
                  ),
                  Center(
                      child: ListView.separated(
                    separatorBuilder: (_, __) => Divider(
                        height: 28.h,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.1)),
                    itemCount: designImages.length,
                    itemBuilder: (context, index) {
                      final item = designImages[index];
                      return GestureDetector(
                        onTap: () => setState(() => selectedIndex = index),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.abc, color: Colors.transparent),
                            Image.asset(item['image'],
                                height: 140, width: 140, fit: BoxFit.cover),
                            customRadio(index == selectedIndex),
                          ],
                        ),
                      );
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customRadio(bool selected) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(0xFF9E2A43),
          width: 1.3,
        ),
      ),
      child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? Color(0xFF9E2A43) : Colors.transparent,
        ),
      ),
    );
  }
}
