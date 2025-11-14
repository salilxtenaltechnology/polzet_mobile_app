// ignore_for_file: deprecated_member_use

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../api/api_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../mixins/utility_mixins.dart';
import '../../../common widgets/base64/image_convert.dart';
import '../../../common widgets/button/back_button.dart';
import '../../../common widgets/custom_text_styles.dart';
import '../../../common widgets/tabbar/indicator_animation.dart';
import '../../../simmer/vibe_revibe_simmer.dart';
import '../public/public_profile.dart';

// ignore: must_be_immutable
class UserFolloersFollowing extends StatefulWidget {
  final String username;
  final int initialIndex;
  final String followerCount;
  final String followingCount;
  UserFolloersFollowing(
      {super.key,
      required this.username,
      required this.initialIndex,
      required this.followerCount,
      required this.followingCount});
  @override
  State<UserFolloersFollowing> createState() => _UserFolloersState();
}

class _UserFolloersState extends State<UserFolloersFollowing>
    with SingleTickerProviderStateMixin, UtilityMixin {
  final ApiService apiService = ApiService();
  late Future<List<Map<String, dynamic>>> getFollowers;
  late Future<List<Map<String, dynamic>>> getFollowing;
  late TabController _tabController;

  bool isFollowing = true;

  @override
  void initState() {
    super.initState();
    getFollowers = apiService.getFollowersList();
    getFollowing = apiService.getFollowingList();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: PrimaryBackButton(),
        title: Text(widget.username,
            style: CustomTextStyles.appBarTitleText(context)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: 25.h,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: FadeUnderlineTabIndicator(),
              labelColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              dividerColor: Colors.transparent,
              unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
              tabs: [
                Tab(
                    text:
                        '${widget.followerCount}  ${AppLocalizations.of(context)!.vibe}'),
                Tab(
                    text:
                        '${widget.followingCount} ${AppLocalizations.of(context)!.revibe}'),
              ],
            ),
            Container(
              height: 33.h,
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 7.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1C000000),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(right: 12.w, left: 12.w, top: 10.h),
                  hintText: AppLocalizations.of(context)!.searchusers,
                  hintStyle: CustomTextStyles.lblPrimaryHintText(context),
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    FeatherIcons.search,
                    size: 17.spMax,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(13.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(13.r)),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Followers Tab
                  Padding(
                    padding:
                        EdgeInsets.only(top: 5.h, left: 2.5.w, right: 2.5.w),
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: getFollowers,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return VibeRevibeSimmer();

                        if (snapshot.hasError)
                          return Center(
                              child: Text('Error: ${snapshot.error}'));

                        final users = snapshot.data!;
                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            final profile_pic =
                                user['profile_picture_url'] as String?;
                            final firstName = user['first_name'] as String? ??
                                user['name'] as String? ??
                                '';
                            final firstLetter = firstName.isNotEmpty
                                ? firstName[0].toUpperCase()
                                : '?';
                            return Container(
                              height: 40.h,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.h),
                              margin: EdgeInsets.only(bottom: 10.h),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x1C000000),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  navigationPush(context,
                                      PublicProfile(userId: user['id']));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 35.h,
                                      width: 35.w,
                                      margin: EdgeInsets.only(right: 5.w),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: const Color(0xFFD1D1D1)
                                                .withOpacity(0.7)),
                                        image: profile_pic != null
                                            ? DecorationImage(
                                                image: MemoryImage(
                                                    getProfileImage(
                                                        profile_pic)!),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                        color: profile_pic == null
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.08)
                                            : null,
                                      ),
                                      child: profile_pic == null
                                          ? Center(
                                              child: Text(
                                                firstLetter,
                                                style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      '${user['username']}',
                                      style: CustomTextStyles.lblSecondryText(
                                          context),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 70.w,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 3.h),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            border: Border.all(
                                                color: Color(0XFFD9D9D9),
                                                width: 1)),
                                        child: Center(
                                            child: Text(
                                          'Remove',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w400),
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // Following Tab
                  Padding(
                    padding:
                        EdgeInsets.only(top: 5.h, left: 2.5.w, right: 2.5.w),
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: getFollowing,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return VibeRevibeSimmer();

                          if (snapshot.hasError)
                            return Center(
                                child: Text('Error: ${snapshot.error}'));

                          final users = snapshot.data!;
                          return ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                final profile_pic =
                                    user['profile_picture_url'] as String?;
                                final firstName =
                                    user['first_name'] as String? ??
                                        user['name'] as String? ??
                                        '';
                                final firstLetter = firstName.isNotEmpty
                                    ? firstName[0].toUpperCase()
                                    : '?';
                                return Container(
                                  height: 40.h,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  margin: EdgeInsets.only(bottom: 10.h),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x1C000000),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      navigationPush(context,
                                          PublicProfile(userId: user['id']));
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 35.h,
                                          width: 35.w,
                                          margin: EdgeInsets.only(right: 5.w),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: const Color(0xFFD1D1D1)
                                                    .withOpacity(0.7)),
                                            image: profile_pic != null
                                                ? DecorationImage(
                                                    image: MemoryImage(
                                                        getProfileImage(
                                                            profile_pic)!),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                            color: profile_pic == null
                                                ? Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.08)
                                                : null,
                                          ),
                                          child: profile_pic == null
                                              ? Center(
                                                  child: Text(
                                                    firstLetter,
                                                    style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          '${user['username']}',
                                          style:
                                              CustomTextStyles.lblSecondryText(
                                                  context),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: 72.w,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 3.h),
                                            decoration: BoxDecoration(
                                                color: isFollowing
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .background
                                                    : AppColors.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                    color: isFollowing
                                                        ? Color(0XFFD9D9D9)
                                                        : AppColors
                                                            .primaryColor,
                                                    width: 1)),
                                            child: Center(
                                                child: Text(
                                              isFollowing
                                                  ? 'Following'
                                                  : 'Follow',
                                              style: TextStyle(
                                                  color: isFollowing
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .onBackground
                                                      : Colors.white,
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                          ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Icon(
                                          Icons.more_vert,
                                          size: 20.spMax,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
