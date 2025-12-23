// ignore_for_file: deprecated_member_use, unused_field, unused_local_variable
part of 'dashboard_import.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

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

  Future<void> fetchHomeFeed() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final fetchedPosts = await ApiService.fetchHomeFeedPosts();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Show loader during initial load
    if (isLoading && isInitialLoad) {
      return HomeFeedSimmer();
    }

    if (errorMessage != null) {
      return ListView(
        children: [
          SizedBox(height: 200.h),
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
                      isInitialLoad = true;
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
          SizedBox(height: 200.h),
          const Center(child: Text('No posts available')),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: fetchHomeFeed,
      child: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(10.w),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return HomeFeedPostCard(post: post, onPressed: () {});
            },
          ),
        ],
      ),
    );
  }
}
