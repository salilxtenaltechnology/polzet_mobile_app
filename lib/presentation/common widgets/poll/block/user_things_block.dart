// ignore_for_file: unused_element, deprecated_member_use, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../api/model/polls/polls_question.dart';

class UserThingsBlock extends StatelessWidget {
  const UserThingsBlock({required this.pollQuestion});

  final PollQuestion pollQuestion;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(pollQuestion.question,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w400)),
          ],
        ),
        SizedBox(height: 10.h),
        // Display poll options
        ...pollQuestion.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _buildPollOption(
              pollQuestion,
              pollQuestion.totalVotesCount,
              context,
              index,
            ),
          );
        }).toList(),
        SizedBox(height: 5.h),
        Text(
          '${pollQuestion.totalVotesCount.toString()} ${pollQuestion.totalVotesCount == 1 ? 'vote' : 'votes'}',
          style: TextStyle(
            fontSize: 10.7.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
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
    final percentage = totalVotes > 0 ? (voteCount / totalVotes * 100) : 0.0;

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
              child: option.text != null && option.image != null
                  ? Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: Image.network(
                            option.image!.url,
                            width: 40.w,
                            height: 40.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 40.w,
                                height: 40.h,
                                color: Colors.grey[300],
                                child: Icon(Icons.image, size: 20.sp),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            option.displayText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      option.text ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
            SizedBox(width: 8.w),
            Text(
              '$voteCount ${voteCount == 1 ? 'vote' : 'votes'}',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Container(
          height: 8.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3), // Semi-transparent white background
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
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }
}