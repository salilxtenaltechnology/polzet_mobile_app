// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:polzet_mobile_app/api/model/home%20feed/home_feed_items_model.dart';

// import '../custom_card.dart';
// import 'home_feed_post_block.dart';

// class HomeFeedPostCard extends StatelessWidget {
//   const HomeFeedPostCard({super.key, required this.postPoll});

//   final HomeFeedPoll postPoll;
 

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12.h),
//       child: CustomCard(
//         widget: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Description
//             // Text(
//             //   post.description,
//             //   style: Theme.of(context).textTheme.titleMedium,
//             // Each poll in this post
//             ...postPoll.options.map((p) => HomeFeedPostBlock(pollQuestion: p)).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
