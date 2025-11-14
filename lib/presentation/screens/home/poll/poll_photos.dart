// ignore_for_file: deprecated_member_use
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../mixins/utility_mixins.dart';
import '../../../common widgets/button/back_button.dart';
import '../../../common widgets/button/primary_button.dart';
import '../../../common widgets/custom_card.dart';
import '../../../common widgets/custom_text_styles.dart';
import 'poll_comments.dart';

class PollPhotos extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PollPhotosState();
  }
}

class PollPhotosState extends State<PollPhotos> with UtilityMixin {
  List<String> imagePaths = [
    Assets.assetsImagesPeople1,
    Assets.assetsImagesPeople2,
    Assets.assetsImagesPeople3,
    Assets.assetsImagesPeople4,
  ];

  // Store the order number (or null if unselected)
  List<int?> selectionOrder = List.filled(4, null);
  int currentOrder = 1;

  void toggleSelection(int index) {
    setState(() {
      if (selectionOrder[index] == null) {
        // Select image
        selectionOrder[index] = currentOrder++;
      } else {
        // Deselect and update others
        int removedOrder = selectionOrder[index]!;
        selectionOrder[index] = null;
        currentOrder--;

        for (int i = 0; i < selectionOrder.length; i++) {
          if (selectionOrder[i] != null && selectionOrder[i]! > removedOrder) {
            selectionOrder[i] = selectionOrder[i]! - 1;
          }
        }
      }
    });
  }

  bool allImagesSelected() {
    return selectionOrder.every((element) => element != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: PrimaryBackButton(),
        title: Text('FOR POLL OPTION',
            style: CustomTextStyles.appBarTitleText(context)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        child: Column(
          children: [
            SizedBox(
              height: 310.h, // You can adjust this value as needed
              child: CustomCard(
                widget: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        padding: EdgeInsets.all(16),
                        children: List.generate(imagePaths.length, (index) {
                          return GestureDetector(
                            onTap: () => toggleSelection(index),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    imagePaths[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                               if (selectionOrder[index] != null)
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${selectionOrder[index]}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30.sp),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              navigationPush(context, PollComments());
                            },
                            child: Icon(
                              FeatherIcons.messageSquare,
                              size: 18.spMax,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          Icon(
                            FeatherIcons.share2,
                            size: 18.spMax,
                            color: Theme.of(context).colorScheme.onBackground,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: allImagesSelected()
          ? BottomAppBar(
              padding: EdgeInsets.zero,
              height: 50.h,
              child: PrimaryButton(
                  title: 'Poll', onPressed: () {}, isLoading: false))
          : null,
    );
  }
}
