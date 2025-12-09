// ignore_for_file: deprecated_member_use, unused_field

part of 'user_profile_import.dart';

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<UserProfile>
    with UtilityMixin, WidgetsBindingObserver, TickerProviderStateMixin {
  final ApiService apiService = ApiService();

  List<PostImagesModel> imagePosts = [];
  List<PostImagesModel> recentImages = [];
  late Future<List<Map<String, dynamic>>> getFollowers;
  late Future<List<Map<String, dynamic>>> getFollowing;
  bool isLoading = true;
  bool isImageLoading = false;
  bool autoRefreshEnabled = true;

  // Add this to track posts and refresh when needed
  Future<List<PostImagesModel>>? _postsFuture;

  // Animation controller and variables for scroll functionality

  late Animation<double> _slideAnimationFollowersFollowing;
  late Animation<double> _slideAnimationPollsThings;
  bool _isVisible = true;
  double _lastScrollOffset = 0;
  final double _scrollThreshold =
      10.0; // Minimum scroll distance to trigger animation

  @override
  void initState() {
    super.initState();

    getFollowers = apiService.getFollowersList();
    getFollowing = apiService.getFollowingList();

    WidgetsBinding.instance.addObserver(this);
    autoRefreshEnabled = true;
    // Initialize with empty data to show "No posts" initially instead of loading
    _postsFuture = Future.value(<PostImagesModel>[]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      _loadFreshPosts(userProvider.username);
      // userProvider.loadUserImages();
    });
  }

  // SOLUTION 1: Create a method to always load fresh posts silently
  void _loadFreshPosts(String? username) {
    // Load fresh data in background without showing loading state
    loadPosts(username).then((freshPosts) {
      if (mounted) {
        _postsFuture = Future.value(freshPosts);
        if (_postsFuture != null) {
          setState(() {
            // This setState only triggers rebuild of FutureBuilder
            // The cover photo and other widgets remain untouched
          });
        }
      }
    }).catchError((error) {
      debugPrint("Error loading fresh posts: $error");
    });
  }

  Future<List<PostImagesModel>> loadPosts(String? username) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (username == null || username.isEmpty) {
      return [];
    }

    try {
      final posts = await apiService.fetchPostsImages(username);

      final imagePosts = posts.where((p) => p.images.isNotEmpty).toList();
      imagePosts.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt)); // Latest posts first
      setState(() {
        // coverImage = userProvider.cover_photo;
      });
      return imagePosts.take(4).toList(); // Return latest 4 posts
    } catch (e) {
      debugPrint("Error loading posts: $e");
      return [];
    }
  }

  // Method to refresh posts data
  void _refreshPosts() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    //userProvider.loadUserData();
    if (userProvider.username != null && userProvider.username!.isNotEmpty) {
      _loadFreshPosts(userProvider.username);
    }
  }

  Uint8List? getProfileImage(profile_picture) {
    if (profile_picture == null || profile_picture.isEmpty) return null;
    try {
      String base64Data =
          profile_picture.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
      return base64Decode(base64Data);
    } catch (e) {
      return null;
    }
  }

  Uint8List? getCoverImage(cover_photo) {
    if (cover_photo == null || cover_photo.isEmpty) return null;
    try {
      String base64Data =
          cover_photo.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
      return base64Decode(base64Data);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    apiService.fetchPostsPolls(userProvider.username!);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 180.h,
              width: double.infinity,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                image: userProvider.cover_photo == null
                    ? DecorationImage(
                        image: AssetImage(Assets.assetsImagesDefaultCover),
                        fit: BoxFit.fill)
                    : DecorationImage(
                        image: MemoryImage(
                            getCoverImage(userProvider.cover_photo)!),
                        fit: BoxFit.fill),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        navigationPush(context, EditProfile());
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 17.h, right: 5.w),
                        height: 24.5.h,
                        width: 24.5.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Center(
                            child: Icon(
                          FeatherIcons.settings,
                          color: Colors.white,
                          size: 16.spMax,
                        )),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 60.h,
                      padding: EdgeInsets.all(8.w),
                      child: Row(
                        children: [
                          Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5.w,
                              ),
                              image: userProvider.profile_picture == null
                                  ? DecorationImage(
                                      image:
                                          AssetImage(Assets.assetsImagesIcUser),
                                      fit: BoxFit.fill)
                                  : DecorationImage(
                                      image: MemoryImage(
                                        getProfileImage(
                                            userProvider.profile_picture)!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    userProvider.isLoading
                                        ? '-'
                                        : userProvider.username ?? '-',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.sp),
                                  ),
                                  SizedBox(width: 5.w),
                                  Image.asset(
                                    Assets.assetsImagesAccVerify,
                                    height: 16.h,
                                    width: 16.w,
                                  )
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                userProvider.isLoading
                                    ? '-'
                                    : userProvider.bio ?? '-',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.sp),
                              ),
                            ],
                          )
                        ],
                      ),
                    ).asGlass(
                        tintColor: Colors.black,
                        clipBorderRadius: BorderRadius.circular(12.r)),
                  ),
                ],
              ),
            ),

            // Main Content Area with Stats and Chase/Re-chase
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Column - Animated (slides left to hide)
                // Use flex: 0 when hidden, flex: 1 when visible for proper space allocation

                SizedBox(
                  width: 100, // Fixed width when visible
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                            color: Color(0xFF9A2C3E),
                            borderRadius: BorderRadius.circular(20.r)),
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        margin: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            statTile(
                                FeatherIcons.arrowUp,
                                userProvider.isLoading
                                    ? '-'
                                    : (userProvider.following_count ?? '-'),
                                () {
                              navigationPush(
                                  context,
                                  UserFolloersFollowing(
                                    username: userProvider.username ?? '-',
                                    followingCount:
                                        userProvider.following_count ?? '0',
                                    followerCount:
                                        userProvider.followers_count ?? '0',
                                    initialIndex: 1,
                                  ));
                            }),
                          ],
                        ),
                      ),
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                            color: Color(0xFF9A2C3E),
                            borderRadius: BorderRadius.circular(20.r)),
                        padding: EdgeInsets.symmetric(vertical: 7.h),
                        margin: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            statTile(
                                FeatherIcons.arrowDown,
                                userProvider.isLoading
                                    ? '-'
                                    : (userProvider.followers_count ?? '-'),
                                () {
                              navigationPush(
                                  context,
                                  UserFolloersFollowing(
                                    username: userProvider.username ?? '-',
                                    followingCount:
                                        userProvider.following_count ?? '0',
                                    followerCount:
                                        userProvider.followers_count ?? '0',
                                    initialIndex: 0,
                                  ));
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Chase/Re-chase Section - Now properly expands to fill remaining width
                // Use flex: 3 to give more space to content area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Row(children: [
                        Text(AppLocalizations.of(context)!.revibe,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w600)),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            navigationPush(
                                context,
                                UserFolloersFollowing(
                                  username: userProvider.username ?? '-',
                                  followingCount:
                                      userProvider.following_count ?? '0',
                                  followerCount:
                                      userProvider.followers_count ?? '0',
                                  initialIndex: 1,
                                ));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: Row(
                              children: [
                                Text(AppLocalizations.of(context)!.seeall,
                                    style: TextStyle(
                                        fontSize: 11.2.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor
                                            .withOpacity(0.8))),
                                Icon(Icons.arrow_forward_ios,
                                    size: 15.5.spMax,
                                    color:
                                        AppColors.primaryColor.withOpacity(0.8))
                              ],
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(height: 5.h),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: getFollowers,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) return VibesSimmer();

                          final users_vibe = snapshot.data ?? [];

                          // 👀 Handle empty list
                          if (users_vibe.isEmpty) {
                            return const Center(
                              child: Text(
                                'No revibe yet 👀',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError)
                            return Center(
                                child: Text('Error: ${snapshot.error}'));

                          final users = snapshot.data!;

                          // Get only the 4 most recently added users
                          final recentUsers =
                              users.length > 4 ? users.take(4).toList() : users;

                          return Container(
                            height: 55.h,
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Row(
                              mainAxisAlignment: users.length < 4
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.spaceBetween,
                              children: recentUsers.map((user) {
                                final profile_pic =
                                    user['profile_picture_url'] as String?;
                                final firstName =
                                    user['first_name'] as String? ??
                                        user['name'] as String? ??
                                        '';
                                final firstLetter = firstName.isNotEmpty
                                    ? firstName[0].toUpperCase()
                                    : '?';

                                return GestureDetector(
                                  onTap: () {
                                    navigationPush(context,
                                        PublicProfile(userId: user['id']));
                                  },
                                  child: Container(
                                    height: 55.h,
                                    width: 55.w,
                                    margin: EdgeInsets.only(right: 5.w),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: const Color(0xFFD1D1D1)
                                              .withOpacity(0.7)),
                                      // Only add image decoration if profile_pic exists
                                      image: profile_pic != null
                                          ? DecorationImage(
                                              image: MemoryImage(
                                                  getProfileImage(
                                                      profile_pic)!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                      // Add background color when no profile picture
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
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 8.h),
                      Row(children: [
                        Text(AppLocalizations.of(context)!.vibe,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w600)),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            navigationPush(
                                context,
                                UserFolloersFollowing(
                                  username: userProvider.username ?? '-',
                                  followingCount:
                                      userProvider.following_count ?? '0',
                                  followerCount:
                                      userProvider.followers_count ?? '0',
                                  initialIndex: 0,
                                ));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!.seeall,
                                    style: TextStyle(
                                        fontSize: 11.2.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor
                                            .withOpacity(0.8))),
                                Icon(Icons.arrow_forward_ios,
                                    size: 15.5.spMax,
                                    color:
                                        AppColors.primaryColor.withOpacity(0.8))
                              ],
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(height: 5.h),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: getFollowers,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) return VibesSimmer();

                          final users_vibe = snapshot.data ?? [];

                          // 👀 Handle empty list
                          if (users_vibe.isEmpty) {
                            return const Center(
                              child: Text(
                                'No chase yet 👀',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError)
                            return Center(
                                child: Text('Error: ${snapshot.error}'));

                          final users = snapshot.data!;

                          // Get only the 4 most recently added users
                          final recentUsers =
                              users.length > 4 ? users.take(4).toList() : users;

                          return Container(
                            height: 55.h,
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Row(
                              mainAxisAlignment: users.length < 4
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.spaceBetween,
                              children: recentUsers.map((user) {
                                final profile_pic =
                                    user['profile_picture_url'] as String?;
                                final firstName =
                                    user['first_name'] as String? ??
                                        user['name'] as String? ??
                                        '';
                                final firstLetter = firstName.isNotEmpty
                                    ? firstName[0].toUpperCase()
                                    : '?';

                                return GestureDetector(
                                  onTap: () {
                                    navigationPush(context,
                                        PublicProfile(userId: user['id']));
                                  },
                                  child: Container(
                                    height: 55.h,
                                    width: 55.w,
                                    margin: EdgeInsets.only(right: 5.w),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: const Color(0xFFD1D1D1)
                                              .withOpacity(0.7)),
                                      // Only add image decoration if profile_pic exists
                                      image: profile_pic != null
                                          ? DecorationImage(
                                              image: MemoryImage(
                                                  getProfileImage(
                                                      profile_pic)!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                      // Add background color when no profile picture
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
                                                fontSize: 22.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 5.h),
                    ],
                  ),
                ),
              ],
            ),
            // Fixed Polls/Things Section - Full Device Width
            Container(
              width: double.infinity, // Full device width
              height: 38.h,
              decoration: BoxDecoration(
                  color: Color(0xFF9A2C3E),
                  borderRadius: BorderRadius.circular(20.r)),
              padding: EdgeInsets.symmetric(vertical: 5.h),
              margin: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  top: 10.h,
                  bottom: 10.h), // Remove horizontal margins for full width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  pollThingsTile(
                      Assets.assetsImagesPoll,
                      (userProvider.image_post_count ?? 0).toString(),
                      Icons.image, () {
                    navigationPush(context,
                        UserImagePosts(username: userProvider.username));
                  }),
                  Container(
                    height: 30.h,
                    child: VerticalDivider(
                      color: const Color(0xA7FFFFFF),
                      thickness: 0.63,
                      width: 1,
                    ),
                  ),
                  pollThingsTile(
                      Assets.assetsImagesThings,
                      (userProvider.text_post_count ?? 0).toString(),
                      Icons.image, () {
                    navigationPush(
                        context,
                        UserThingsQuestionsList(
                            username: userProvider.username ?? '-'));
                  }),
                ],
              ),
            ),
            // Posts Section
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.poll,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600)),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      navigationPush(context,
                          UserImagePosts(username: userProvider.username));
                    },
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.seeall,
                            style: TextStyle(
                                fontSize: 11.2.sp,
                                fontWeight: FontWeight.w600,
                                color:
                                    AppColors.primaryColor.withOpacity(0.8))),
                        Icon(Icons.arrow_forward_ios,
                            size: 15.5.spMax,
                            color: AppColors.primaryColor.withOpacity(0.8))
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: FutureBuilder<List<PostImagesModel>>(
                key: ValueKey(_postsFuture.hashCode),
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 110.h,
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 5.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          Container(
                            height: 110.h,
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 5.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          )
                        ],
                      ),
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.grey[600],
                            size: 50,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Error loading posts',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          ElevatedButton(
                            onPressed: _refreshPosts,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  final posts = snapshot.data ?? [];
                  if (posts.isEmpty) {
                    return Center(
                      child: DottedBorder(
                        options: CustomPathDottedBorderOptions(
                          strokeWidth: 1.8,
                          dashPattern: [6, 4],
                          customPath: (size) => Path()
                            ..moveTo(0, size.height)
                            ..relativeLineTo(size.width, 0),
                          color: AppColors.primaryColor.withOpacity(0.6),
                          borderPadding: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            navigationPush(context, AddPollImage());
                          },
                          child: Container(
                              height: 100.h,
                              width: double.infinity,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Create Something Cool'),
                                  Container(
                                    height: 27.h,
                                    width: 200.w,
                                    margin: EdgeInsets.only(top: 8.h),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFB91C1C), // deep red
                                          Color(0xFFDB2777), // pink
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Create your first poll',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.5.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))),
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 columns
                      crossAxisSpacing: 8, // Horizontal spacing between items
                      mainAxisSpacing: 8, // Vertical spacing between items
                      childAspectRatio:
                          1.3, // Adjusted ratio for better image display
                    ),
                    itemCount: posts.length > 4 ? 4 : posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return _buildImagesStack(post.images);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0.h),
              child: Row(
                children: [
                  Text('Things',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600)),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      navigationPush(
                          context,
                          UserThingsQuestionsList(
                              username: userProvider.username!));
                    },
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.seeall,
                            style: TextStyle(
                                fontSize: 11.2.sp,
                                fontWeight: FontWeight.w600,
                                color:
                                    AppColors.primaryColor.withOpacity(0.8))),
                        Icon(Icons.arrow_forward_ios,
                            size: 15.5.spMax,
                            color: AppColors.primaryColor.withOpacity(0.8))
                      ],
                    ),
                  ),
                ],
              ),
            ),

            FutureBuilder<List<PostPolls>>(
              future: apiService.fetchOnlyPollPosts(userProvider.username!),
              builder: (context, snapshot) {
                // Show loading indicator
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.h),
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                }

                // Show error message
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final postsPolls = snapshot.data ?? const <PostPolls>[];

                // Filter posts with polls
                final postsWithPolls =
                    postsPolls.where((post) => post.polls.isNotEmpty).toList();

                // Show empty state if no posts with polls
                if (postsWithPolls.isEmpty) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: DottedBorder(
                      options: CustomPathDottedBorderOptions(
                          strokeWidth: 1.8,
                          dashPattern: [6, 4],
                          customPath: (size) => Path()
                            ..moveTo(0, size.height)
                            ..relativeLineTo(size.width, 0),
                          color: AppColors.primaryColor.withOpacity(0.6),
                          borderPadding: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                        ),
                      child: Container(
                        height: 100.h,
                        width: double.infinity,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              navigationPush(context, AddPollAnswer());
                            },
                            child: Container(
                              height: 27.h,
                              width: 200.w,
                              margin: EdgeInsets.only(top: 8.h),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFB91C1C), // deep red
                                    Color(0xFFDB2777), // pink
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Create your first poll',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // Show list of polls (max 3)
                return ListView.builder(
                  padding: EdgeInsets.all(12.w),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      postsWithPolls.length > 3 ? 3 : postsWithPolls.length,
                  itemBuilder: (context, index) {
                    const List<List<Color>> gradientOptions = [
                      [Color(0xFFFC3E7E), Color(0xFFEEA0F0)],
                      [Color(0xFF4FC3F7), Color(0xFFB6E2F8)],
                      [Colors.red, Color(0xFFEFB0C3)],
                    ];

                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: index < postsWithPolls.length - 1 ? 12.h : 0),
                      child: UserThingsCard(
                        post: postsWithPolls[index],
                        gradientColors:
                            gradientOptions[index % gradientOptions.length],
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget statTile(IconData icon, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(Assets.assetsImagesCurrentUser,
                    height: 18.5.h, width: 18.5.w),
                SizedBox(height: 2.h),
                Icon(icon,
                    size: 20.spMax, color: Colors.white.withOpacity(0.8)),
                SizedBox(height: 2.h),
                Image.asset(Assets.assetsImagesAddUsers,
                    height: 18.5.h, width: 18.5.w),
              ],
            ),
            SizedBox(width: 7.h),
            Text(value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }

  Widget pollThingsTile(
      String icon, String value, IconData pollImage, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        width: 130.w,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(width: 5.w),
            // Icon(pollImage,size: 18.spMax,color: Colors.white),
            Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Image.asset(icon, height: 19.h, width: 19.w),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesStack(List images) {
    // Define alignments based on total image count
    List<Alignment> getAlignments(int totalImages) {
      switch (totalImages) {
        case 1:
          return [Alignment.center];
        case 2:
          return [Alignment.centerLeft, Alignment.centerRight];
        case 3:
          return [
            Alignment.centerLeft,
            Alignment.center,
            Alignment.centerRight
          ];
        case 4:
        default:
          return [
            Alignment.centerLeft,
            Alignment.center,
            Alignment.centerRight,
            Alignment.centerRight
          ];
      }
    }

    List<Alignment> alignments = getAlignments(images.length);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Get available width from GridView cell
        double availableWidth = constraints.maxWidth;
        double availableHeight = constraints.maxHeight;

        // Fixed height for images
        double imageHeight = 120.h; // Fixed height

        return SizedBox(
          height: availableHeight,
          width: availableWidth,
          child: Stack(
            children: images
                .asMap()
                .entries
                .map<Widget>((entry) {
                  int index = entry.key;
                  dynamic imageData = entry.value;

                  // Get alignment for current index
                  Alignment alignment = alignments[index];

                  // Calculate width based on available GridView cell width
                  double imageWidth = (availableWidth * 0.7) - (index * 8.0);

                  // Ensure minimum width
                  imageWidth = imageWidth < 60.w ? 60.w : imageWidth;

                  return Align(
                    alignment: alignment,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      width: imageWidth,
                      height: imageHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(19.r),
                          child: Image.network(
                            '${ApiConfig.baseUrlImage}${imageData.url}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey[600],
                                  size: 30,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                })
                .toList() // set image layer first to last
                .reversed
                .toList(), // Reverse the list so index[0] appears on top
          ),
        );
      },
    );
  }
}
