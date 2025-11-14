class Follower {
  final String id;
  final String userName;
  final String fullName;

  Follower({
    required this.id,
    required this.userName,
    required this.fullName,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      id: json['id'] ?? '',
      userName: json['user_name'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }
}
