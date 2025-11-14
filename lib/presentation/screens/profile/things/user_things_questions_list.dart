// ignore_for_file: deprecated_member_use, unused_field, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../api/api_service.dart';
import '../../../../api/model/posts/post_polls_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common widgets/button/back_button.dart';
import '../../../common widgets/custom_text_styles.dart';
import '../../../common widgets/loader.dart';
import '../../../common widgets/poll/card/things_qustions_card.dart';

class UserThingsQuestionsList extends StatefulWidget {
  String? username;
  UserThingsQuestionsList({super.key, required this.username});

  @override
  State<UserThingsQuestionsList> createState() => _PollThingsState();
}

class _PollThingsState extends State<UserThingsQuestionsList> {
  late final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: PrimaryBackButton(),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.pollthings,
            style: CustomTextStyles.appBarTitleText(context)),
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
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
