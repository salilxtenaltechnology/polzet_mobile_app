// ignore_for_file: unused_element, deprecated_member_use, unused_local_variable
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../api/services/api_service.dart';
import '../../../models/polls/poll_question_model.dart';
import '../../diolog/custom_diolog.dart';

class ThingsQuestionsBlock extends StatelessWidget {
  ThingsQuestionsBlock({super.key, required this.pollQuestion});

  final PollQuestion pollQuestion;
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              pollQuestion.question,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print('ID : ${pollQuestion.id}');
                }
                showUserDeletePostDiolog(context, () {
                  apiService.userDeletePost(pollQuestion.id);
                });
              },
              child: Icon(Icons.more_vert, size: 17.spMax),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ...pollQuestion.options.map(
          (option) => _buildPollOption(
            pollQuestion,
            pollQuestion.totalVotesCount,
            context,
            pollQuestion.options.indexOf(option),
          ),
        ),
        Text(
          '${pollQuestion.totalVotesCount} votes',
          style: TextStyle(
            fontSize: 10.7.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPollOption(
    final PollQuestion pollQuestion,
    int totalVotes,
    BuildContext context,
    int optionIndex,
  ) {
    final option = pollQuestion.options[optionIndex];

    // Parse vote count from String to int
    final voteCount = option.voteCountInt;

    // Calculate percentage
    final percentage = totalVotes > 0 ? (voteCount / totalVotes * 100) : 0;

    // Define different gradient colors for dynamic options
    List<Color> getGradientColors(int index) {
      final colors = [
        [Color(0xFFFC3E7E), Color(0xFFEEA0F0)], // Option 1
        [Color(0xFF4FC3F7), Color(0xFFB6E2F8)], // Option 2
        [Colors.red, Color(0xFFEFB0C3)], // Option 3
        [Colors.green, Colors.teal], // Option 4
        [Colors.orange, Colors.deepOrange], // Option 5
        [Colors.purple, Colors.deepPurple], // Option 6
      ];
      return colors[index % colors.length];
    }

    final gradientColors = getGradientColors(optionIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                option.displayText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            voteCount == 0
                ? Text('')
                : Text(
                    '$voteCount ${voteCount == 1 ? 'vote' : 'votes'}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          height: 8.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200], // Grey background for unfilled area
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: Stack(
              children: [
                // Only show filled area if percentage > 0
                if (percentage > 0)
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      height: 8.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
