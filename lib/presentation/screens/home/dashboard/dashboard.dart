// ignore_for_file: deprecated_member_use, unused_field, unused_local_variable
part of 'dashboard_import.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> with UtilityMixin {
  late final ApiService apiService = ApiService();
  List<HomeFeedPost> posts = [];
  bool isLoading = false;
  bool isInitialLoad = true;
  String? errorMessage;

  // Sample categories list (you can replace this with your actual data)
  final List<Category> categories = [
    Category(name: 'Sports', icon: Icons.sports_soccer),
    Category(name: 'Movie', icon: Icons.movie),
    Category(name: 'Tech', icon: Icons.laptop),
    Category(name: 'Trending polls', icon: Icons.trending_up),
    Category(name: 'Music', icon: Icons.music_note),
    Category(name: 'Gaming', icon: Icons.games),
  ];

  // Cache configuration
  static const String _cacheKey = 'home_feed_cache';
  static const String _cacheTimeKey = 'home_feed_cache_time';
  static const Duration _cacheValidDuration = Duration(minutes: 10);

  @override
  void initState() {
    super.initState();
    fetchHomeFeed();
  }

  // Future<void> _initializeData() async {
  //   await _loadCachedData();
  //   // Always fetch new data in background after showing cached data
  //   if (posts.isNotEmpty) {
  //     _fetchInBackground();
  //   } else {
  //      fetchHomeFeed();
  //   }
  // }

  // Future<void> _loadCachedData() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final cachedJson = prefs.getString(_cacheKey);
  //     final lastCacheTime = prefs.getInt(_cacheTimeKey);

  //     if (cachedJson != null && lastCacheTime != null) {
  //       final cacheTime = DateTime.fromMillisecondsSinceEpoch(lastCacheTime);
  //       final isExpired =
  //           DateTime.now().difference(cacheTime) > _cacheValidDuration;

  //       // Show cached data even if expired (for instant display)
  //       final List<dynamic> jsonList = jsonDecode(cachedJson);
  //       final cachedPosts =
  //           jsonList.map((json) => HomeFeedPost.fromJson(json)).toList();

  //       setState(() {
  //         posts = cachedPosts;
  //         isInitialLoad = false;
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     await _clearCache();
  //   }
  // }

  // Future<void> _fetchInBackground() async {
  //   try {
  //     final fetchedPosts = await ApiService.fetchHomeFeedPosts();
  //     await _saveCacheData(fetchedPosts);

  //     // Update UI only if data is different
  //     if (fetchedPosts.length != posts.length) {
  //       setState(() {
  //         posts = fetchedPosts;
  //       });
  //     }
  //   } catch (e) {
  //     // Silently fail background fetch
  //   }
  // }

  // Future<void> _saveCacheData(List<HomeFeedPost> postsToCache) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     // Alternative approach: Convert to JSON manually
  //     final jsonList = postsToCache
  //         .map((post) => {
  //               'id': post.id,
  //               'user': post.user,
  //               'description': post.description,
  //               'created_at': post.createdAt,
  //               'images': post.images
  //                   .map((image) => {
  //                         'id': image.id,
  //                         'url': image.url,
  //                         'thumbnail_url': image.thumbnailUrl,
  //                         'order': image.order,
  //                         'vote_count': image.voteCount,
  //                       })
  //                   .toList(),
  //               'polls': post.polls
  //                   .map((poll) => {
  //                         'id': poll.id,
  //                         'question': poll.question,
  //                         'max_options': poll.maxOptions,
  //                         'options': poll.options
  //                             .map((option) => {
  //                                   'id': option.id,
  //                                   'text': option.text,
  //                                   'vote_count': option.voteCount,
  //                                 })
  //                             .toList(),
  //                         'total_votes': poll.totalVotes,
  //                         'user_vote': poll.userVote,
  //                       })
  //                   .toList(),
  //               'comments': [], // Simplified since HomeFeedComment is empty
  //             })
  //         .toList();

  //     final jsonString = jsonEncode(jsonList);

  //     await prefs.setString(_cacheKey, jsonString);
  //     await prefs.setInt(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
  //   } catch (e) {
  //     // Handle error silently
  //     print('Error saving cache: $e'); // Add this for debugging
  //   }
  // }

  // Future<void> _clearCache() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.remove(_cacheKey);
  //     await prefs.remove(_cacheTimeKey);
  //   } catch (e) {
  //     // Handle error silently
  //   }
  // }

  Future<void> fetchHomeFeed() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final fetchedPosts = await ApiService.fetchHomeFeedPosts();

      // Save to cache
      //await _saveCacheData(fetchedPosts);

      setState(() {
        posts = fetchedPosts;
        isLoading = false;
        isInitialLoad = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
        isInitialLoad = false;
      });
    }
  }

  Widget _buildCategorySections() {
    return Container(
      height: 100, // Fixed height to maintain UI consistency
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            width: 110.w,
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.from(
                      alpha: 1,
                      red: 0.922,
                      green: 0.878,
                      blue: 0.898), // light pink
                  Color(0xFFFFEDF4), // soft rose
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(categories[index].icon,
                    size: 30, color: Theme.of(context).colorScheme.primary),
                SizedBox(height: 3.h),
                Text(
                  categories[index].name,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    // Show shimmer only on initial load (first time seeing screen)
    if (isInitialLoad) {
      return ListView(
        children: [
          _buildCategorySections(),
          HomeFeedSimmer(),
        ],
      );
    }

    if (errorMessage != null) {
      return ListView(
        children: [
          _buildCategorySections(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: $errorMessage',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isInitialLoad = true; // Reset for retry
                    });
                    fetchHomeFeed();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (posts.isEmpty && !isLoading) {
      return ListView(
        children: [
          _buildCategorySections(),
          SizedBox(height: 200.h),
          const Center(
            child: Text('No posts available'),
          ),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: fetchHomeFeed,
      child: ListView(
        children: [
          _buildCategorySections(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(10.w),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return HomeFeedPostCard(
                  post: post,
                  onPressed: () {
                    // navigationPush(context, PublicProfile(userId: post.id));
                  });
            },
          ),
        ],
      ),
    );
  }
}
