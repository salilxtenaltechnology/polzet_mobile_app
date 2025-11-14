class PublicPollOption {
  final int id;
  final String text;
  final int voteCount;

  PublicPollOption({
    required this.id,
    required this.text,
    required this.voteCount,
  });

  factory PublicPollOption.fromJson(Map<String, dynamic> json) => PublicPollOption(
        id: json['id'] as int,
        text: json['text'] as String? ?? '',
        voteCount: json['vote_count'] as int? ?? 0,
      );
}