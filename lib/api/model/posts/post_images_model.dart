import '../polls/polls_question.dart';
import '../polls/post_image_model.dart';

class PostImagesModel {
  final int id;
  final String user;
  final String description;
  final DateTime createdAt;
  final List<PollQuestion> pollQuestion;
  final List<PostImage> images;

  PostImagesModel(
      {required this.id,
      required this.user,
      required this.description,
      required this.createdAt,
      required this.pollQuestion,
      required this.images});

  factory PostImagesModel.fromJson(Map<String, dynamic> json) => PostImagesModel(
        id: json['id'] as int,
        user: json['user'] as String,
        description: json['description'] as String? ?? '',
        createdAt: DateTime.parse(json['created_at'] as String),
        pollQuestion: (json['polls'] as List<dynamic>?)
                ?.map((e) => PollQuestion.fromJson(e as Map<String, dynamic>))
                .toList() ??
            <PollQuestion>[],
        images: (json['images'] as List<dynamic>)
            .map((e) => PostImage.fromJson(e))
            .toList(),
      );
}
