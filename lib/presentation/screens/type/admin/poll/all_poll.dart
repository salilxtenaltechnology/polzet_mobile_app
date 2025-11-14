// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polzet_mobile_app/presentation/common%20widgets/custom_card.dart';
import 'package:polzet_mobile_app/presentation/common%20widgets/custom_text_styles.dart';

import '../../../../../l10n/generated/app_localizations.dart';
import '../../../../../mixins/utility_mixins.dart';
import '../../../../common widgets/button/back_button.dart';
import 'poll_results.dart';

class AllPoll extends StatefulWidget {
  const AllPoll({super.key});

  @override
  State<AllPoll> createState() => _AllPollState();
}

class _AllPollState extends State<AllPoll> with UtilityMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading:PrimaryBackButton(),
          centerTitle: true,
          title: Text(
           AppLocalizations.of(context)!.allpolls,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Theme.of(context).colorScheme.background,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  navigationPush(context, PollResults());
                },
                child: CustomCard(
                    widget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Poll - 1',
                      style:CustomTextStyles.lblPrimaryText(context)
                    ),
                    Text(
                      '1252',
                     style:CustomTextStyles.lblPrimaryText(context)
                    ),
                  ],
                )),
              ),
              SizedBox(height: 15.h),
              CustomCard(
                  widget: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Poll - 2',
                    style:CustomTextStyles.lblPrimaryText(context)
                  ),
                  Text(
                    '1252',
                     style:CustomTextStyles.lblPrimaryText(context)
                  ),
                ],
              )),
            ],
          ),
        ));
  }
}
