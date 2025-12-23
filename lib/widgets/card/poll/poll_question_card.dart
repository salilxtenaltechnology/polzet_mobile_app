import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/posts/post_polls_model.dart';
import 'poll_question_block.dart';

class ThingsQustionsCard extends StatelessWidget {
  const ThingsQustionsCard({super.key, required this.post});

  final PostPolls post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10).w,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            // Text(
            //   post.description,
            //   style: Theme.of(context).textTheme.titleMedium,
            // Each poll in this post
            ...post.polls.map((p) => ThingsQuestionsBlock(pollQuestion: p)),
          ],
        ),
      ),
    );
  }
}
