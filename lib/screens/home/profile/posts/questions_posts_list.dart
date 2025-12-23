// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../api/services/api_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../models/posts/post_polls_model.dart';
import '../../../../widgets/button/back_button.dart';
import '../../../../widgets/card/poll/poll_question_card.dart';
import '../../../../widgets/custom_text_styles.dart';
import '../../../../widgets/loader.dart';

class QuestionsPostsList extends StatefulWidget {
   String? username;
   QuestionsPostsList({super.key,required this.username});

  @override
  State<QuestionsPostsList> createState() => _QuestionsPostsListState();
}

class _QuestionsPostsListState extends State<QuestionsPostsList> {

late final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: PrimaryBackButton(),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.pollthings,
            style: CustomTextStyles.appBarTitleText(context)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
      ),
      body: FutureBuilder<List<PostPolls>>(
        future: apiService.fetchPostsPolls(widget.username!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Loader(color: Theme.of(context).colorScheme.primary));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final postsPolls = snapshot.data ?? const <PostPolls>[];
          if (postsPolls.isEmpty) {
            return const Center(child: Text('No polls found'));
          }
          final postsWithPolls =
              postsPolls.where((post) => post.polls.isNotEmpty).toList();

          if (postsWithPolls.isEmpty) {
            return const Center(child: Text('No active polls found'));
          }

          return ListView.builder(
            padding:  EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
            itemCount: postsWithPolls.length,
            itemBuilder: (context, index) {
              return ThingsQustionsCard(
                post: postsWithPolls[index],
              );
            },
          );
        },
      ),
    );
  }
}
