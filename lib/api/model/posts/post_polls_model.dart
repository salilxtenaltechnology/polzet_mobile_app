import '../polls/polls_question.dart';

class PostImage {
  final int id;
  final String url;
  final String thumbnailUrl;
  final int order;
  final int voteCount;

  PostImage({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    required this.order,
    required this.voteCount,
  });

  factory PostImage.fromJson(Map<String, dynamic> json) => PostImage(
        id: json['id'] as int,
        url: json['url'] as String? ?? '',
        thumbnailUrl: json['thumbnail_url'] as String? ?? '',
        order: json['order'] as int? ?? 0,
        voteCount: json['vote_count'] as int? ?? 0,
      );
}

class PostPolls {
  final int id;
  final String user;
  final String description;
  final DateTime createdAt;
  final List<PostImage> images;
  final List<PollQuestion> polls;
  final List<dynamic> comments;
  final int likesCount;
  final bool isLiked;

  PostPolls({
    required this.id,
    required this.user,
    required this.description,
    required this.createdAt,
    required this.images,
    required this.polls,
    required this.comments,
    required this.likesCount,
    required this.isLiked,
  });

  factory PostPolls.fromJson(Map<String, dynamic> json) => PostPolls(
        id: json['id'] as int,
        user: json['user'] as String,
        description: json['description'] as String? ?? '',
        createdAt: DateTime.parse(json['created_at'] as String),
        images: (json['images'] as List<dynamic>?)
                ?.map((e) => PostImage.fromJson(e as Map<String, dynamic>))
                .toList() ??
            <PostImage>[],
        polls: (json['polls'] as List<dynamic>?)
                ?.map((e) => PollQuestion.fromJson(e as Map<String, dynamic>))
                .toList() ??
            <PollQuestion>[],
        comments: (json['comments'] as List<dynamic>?) ?? <dynamic>[],
        likesCount: json['likes_count'] as int? ?? 0,
        isLiked: json['is_liked'] as bool? ?? false,
      );
  
  // Helper to check if this post has text-based polls only (no image polls)
  bool get hasOnlyTextPolls {
    if (polls.isEmpty) return false;
    return polls.every((poll) => 
      poll.options.every((option) => option.text != null && option.text!.isNotEmpty)
    );
  }
}