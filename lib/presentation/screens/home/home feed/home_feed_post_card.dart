// ignore_for_file: deprecated_member_use, unused_local_variable, must_be_immutable, unused_element

import 'dart:math';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../api/api_config.dart';
import '../../../../api/model/home feed/home_feed_items_model.dart';
import '../../../../core/constants/app_images.dart';
import '../../../common widgets/custom_text_styles.dart';
import '../../../common widgets/diolog/custom_diolog.dart';
import '../../../common widgets/loader.dart';

class HomeFeedPostCard extends StatefulWidget {
  final HomeFeedPost post;
  final VoidCallback? onPressed;
  Function(List<int>)?
      onImageSelectionChanged; // Added callback for selection changes

  HomeFeedPostCard(
      {super.key,
      required this.post,
      this.onPressed,
      this.onImageSelectionChanged});

  @override
  State<HomeFeedPostCard> createState() => _HomeFeedPostCardState();
}

class _HomeFeedPostCardState extends State<HomeFeedPostCard> {
  bool isLike = false;
  List<int> randomImageIndices = [];
  late Random random;
  List<int> selectionOrder = []; // Track the order of selection

  // Changed to support multiple selections per poll
  Map<String, List<int>> selectedOptions = {};

  // Get the selection number for an image (1, 2, 3, etc.)
  int getSelectionNumber(int imageNumber) {
    int index = selectionOrder.indexOf(imageNumber);
    return index == -1 ? 0 : index + 1;
  }

  // Check if an image is selected
  bool isImageSelected(int imageNumber) {
    return selectionOrder.contains(imageNumber);
  }

  // Check if all images are selected
  bool get areAllImagesSelected {
    return randomImageIndices.isNotEmpty &&
        selectionOrder.length == randomImageIndices.length;
  }

  // Get selected image data
  List<int> get selectedImageIndices {
    List<int> indices = [];
    selectionOrder.forEach((number) {
      if (number <= randomImageIndices.length) {
        indices.add(randomImageIndices[number - 1]);
      }
    });
    return indices;
  }

  // Get unselected image data
  List<int> get unselectedImageIndices {
    Set<int> selectedSet = selectedImageIndices.toSet();
    return randomImageIndices
        .where((index) => !selectedSet.contains(index))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    random = Random();
    _generateRandomImageIndices();
  }

  void _generateRandomImageIndices() {
    if (widget.post.images.isNotEmpty) {
      // Create a list of all available indices
      List<int> allIndices =
          List.generate(widget.post.images.length, (index) => index);

      // Shuffle and take up to 3 images
      allIndices.shuffle(random);
      int maxImages =
          widget.post.images.length >= 3 ? 3 : widget.post.images.length;
      randomImageIndices = allIndices.take(maxImages).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only show posts that have either images or polls (not empty)
    final bool hasImages = widget.post.images.isNotEmpty;
    final bool hasPolls = widget.post.polls.isNotEmpty;

    if (!hasImages && !hasPolls) {
      return const SizedBox
          .shrink(); // Don't show posts with empty images and polls
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 15.h),
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(30, 0, 0, 0),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(right: 10.w, left: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User and menu
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onPressed,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.15),
                        child: Text(
                          widget.post.user.firstLetter,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.user.username,
                          style: TextStyle(
                            fontSize: 12.8.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Placed a post',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        showUserInfoDiolog(context, Navigator.of(context).pop);
                      },
                      child: Icon(Icons.more_vert,
                          size: 18.spMax,
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ],
                ),

                // Images Section - Only when hasImages is true AND hasPolls is false
                if (hasImages) _buildImagesSection(context),

                // Polls Section - Only when hasPolls is true AND hasImages is false
                if (hasPolls) _buildPollsSection(context),

                // Action buttons
                SizedBox(height: 3.h),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            isLike = !isLike;
                          });
                        },
                        child: isLike
                            ? Image.asset(
                                Assets.assetsImagesIcHeartFilled,
                                height: 23.h,
                                width: 23.w,
                              )
                            : Image.asset(
                                Assets.assetsImagesIcHeart,
                                height: 23.h,
                                width: 23.w,
                              )),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(FeatherIcons.messageSquare,
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(FeatherIcons.send,
                          size: 18.spMax,
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    Spacer(),
                  ],
                ),
                // Bottom center button - only show when all images are selected
                if (hasImages && areAllImagesSelected)
                  Center(
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: 1.0,
                      child: Container(
                        margin: EdgeInsets.only(top: 10.h),
                        height: 45.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFCF4B73),
                                Color(0xFFC76294),
                              ]),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.analytics,
                          color: Colors.white,
                          size: 22.spMax,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageWithNumber(String imageUrl, int number, double height,
      {BoxFit fit = BoxFit.cover}) {
    bool isSelected = isImageSelected(number);
    int selectionNumber = getSelectionNumber(number);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isImageSelected(number)) {
            // Remove from selection order
            selectionOrder.remove(number);
          } else {
            // Add to selection order
            selectionOrder.add(number);
          }
        });
        // Notify parent about selection changes
        if (widget.onImageSelectionChanged != null) {
          widget.onImageSelectionChanged!(selectedImageIndices);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          height: height,
          child: Stack(
            children: [
              // Image with overlay when selected
              Stack(
                children: [
                  Image.network(
                    imageUrl,
                    height: height,
                    width: double.infinity,
                    fit: fit,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: height,
                        color: Colors.grey[200],
                        child: Center(
                          child: Loader(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: height,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  // Semi-transparent overlay when selected
                  if (isSelected)
                    Container(
                      height: height,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                ],
              ),
              // Number overlay - show selection number when selected
              if (isSelected)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: 1.0,
                    child: Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$selectionNumber',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagesSection(BuildContext context) {
    if (randomImageIndices.isEmpty) return const SizedBox.shrink();

    if (randomImageIndices.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description (only if not empty)
          if (widget.post.description.isNotEmpty &&
              widget.post.description != 'fkglfd')
            Padding(
              padding: EdgeInsets.only(top: 5.h, bottom: 8.h),
              child: Text(widget.post.description,
                  style: CustomTextStyles.lblSecondryText(context)),
            ),
          _buildImageWithNumber(
            '${ApiConfig.baseUrlImage}${widget.post.images[randomImageIndices[0]].url}',
            1,
            200.h,
          ),
        ],
      );
    } else if (randomImageIndices.length == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description (only if not empty)
          if (widget.post.description.isNotEmpty &&
              widget.post.description != 'fkglfd')
            Padding(
              padding: EdgeInsets.only(top: 5.h, bottom: 8.h),
              child: Text(widget.post.description,
                  style: CustomTextStyles.lblSecondryText(context)),
            ),
          Row(
            children: [
              Expanded(
                child: _buildImageWithNumber(
                  '${ApiConfig.baseUrlImage}${widget.post.images[randomImageIndices[0]].url}',
                  1,
                  150.h,
                ),
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: _buildImageWithNumber(
                  '${ApiConfig.baseUrlImage}${widget.post.images[randomImageIndices[1]].url}',
                  2,
                  150.h,
                ),
              ),
            ],
          ),
        ],
      );
    } else if (randomImageIndices.length >= 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description (only if not empty)
          if (widget.post.description.isNotEmpty &&
              widget.post.description != 'fkglfd')
            Padding(
              padding: EdgeInsets.only(top: 5.h, bottom: 8.h),
              child: Text(widget.post.description,
                  style: CustomTextStyles.lblSecondryText(context)),
            ),
          Row(
            children: [
              Expanded(
                child: _buildImageWithNumber(
                  '${ApiConfig.baseUrlImage}${widget.post.images[randomImageIndices[0]].url}',
                  1,
                  150.h,
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: _buildImageWithNumber(
                  '${ApiConfig.baseUrlImage}${widget.post.images[randomImageIndices[1]].url}',
                  2,
                  150.h,
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: _buildImageWithNumber(
                  '${ApiConfig.baseUrlImage}${widget.post.images[randomImageIndices[2]].url}',
                  3,
                  150.h,
                ),
              ),
            ],
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

 Widget _buildPollsSection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: widget.post.polls.map((poll) {
      // Check if any option has null or empty text
      bool hasInvalidOption = poll.options.any((option) => option.text.isEmpty);
      
      // If any option is invalid, don't render this poll at all
      if (hasInvalidOption) {
        return SizedBox.shrink();
      }

      // Check if all options in this poll are selected
      String pollKey = poll.id.toString();
      bool areAllOptionsSelected = _areAllPollOptionsSelected(poll);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.h),
          Text(
            poll.question,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10.h),
          ...poll.options.asMap().entries.map((entry) => _buildPollOption(
                entry.value,
                poll.totalVotes,
                context,
                entry.key,
                poll,
              )),
          SizedBox(height: 5.h),
          Text(
            '${poll.totalVotes.toString()} Votes',
            style: TextStyle(
              fontSize: 10.7.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),

          // Show analytics button when all options are selected
          if (areAllOptionsSelected)
            Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: 1.0,
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  height: 45.h,
                  width: 45.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFCF4B73),
                        Color(0xFFC76294),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.3),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.stacked_bar_chart,
                    color: Colors.white,
                    size: 20.spMax,
                  ),
                ),
              ),
            ),
        ],
      );
    }).toList(),
  );
}

// Helper method to check if all options in a poll are selected
  bool _areAllPollOptionsSelected(HomeFeedPoll poll) {
    String pollKey = poll.id.toString();

    // Check if this poll has selections and if all options are selected
    if (!selectedOptions.containsKey(pollKey)) {
      return false;
    }

    // Count only valid options (non-empty text)
    int validOptionsCount =
        poll.options.where((option) => option.text.isNotEmpty).length;

    return selectedOptions[pollKey]!.length == validOptionsCount;
  }

// Helper method to get selection number for an option
  int? _getSelectionNumber(String pollKey, int optionIndex) {
    if (!selectedOptions.containsKey(pollKey)) {
      return null;
    }

    // Get the list of selected indices in order of selection
    List<int> selected = selectedOptions[pollKey]!;

    // If this option is not selected, return null
    if (!selected.contains(optionIndex)) {
      return null;
    }

    // Return the position (1-indexed) based on when it was selected
    return selected.indexOf(optionIndex) + 1;
  }

  Widget _buildPollOption(HomeFeedPollOption option, int totalVotes,
      BuildContext context, int optionIndex, HomeFeedPoll poll) {
    final percentage =
        totalVotes > 0 ? ((option.voteCount) / totalVotes * 100) : 0.0;

    // Define different gradient colors for dynamic options
    List<Color> getGradientColors(int index) {
      final colors = [
        [Color(0xFFFC3E7E), Color(0xFFEEA0F0)], // Option 1
        [Color(0xFF4FC3F7), Color(0xFFB6E2F8)], // Option 2
        [Colors.red, const Color(0xFFEFB0C3)], // Option 3
        [Colors.green, Colors.teal], // Option 4
      ];
      return colors[index % colors.length];
    }

    final gradientColors = getGradientColors(optionIndex);

    int percentage_full = 100;
    int total_vote_count = ((option.voteCount * 100) / percentage_full).round();

    // Check if this option is selected
    String pollKey = poll.id.toString();
    bool isSelected = selectedOptions.containsKey(pollKey) &&
        selectedOptions[pollKey]!.contains(optionIndex);

    // Get selection number
    int? selectionNumber = _getSelectionNumber(pollKey, optionIndex);

    return GestureDetector(
      onTap: () {
        // Handle option selection/deselection
        setState(() {
          // Initialize the list if it doesn't exist
          if (!selectedOptions.containsKey(pollKey)) {
            selectedOptions[pollKey] = [];
          }

          // Toggle selection
          if (selectedOptions[pollKey]!.contains(optionIndex)) {
            // If already selected, unselect it
            selectedOptions[pollKey]!.remove(optionIndex);
          } else {
            // If not selected, add it to the end (preserves selection order)
            selectedOptions[pollKey]!.add(optionIndex);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                  width: 1.1)
              : Border.all(color: Colors.transparent, width: 1.5),
          borderRadius: BorderRadius.circular(8.r),
          color: isSelected
              ? const Color.fromARGB(24, 0, 0, 0)
              : Colors.transparent,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Show selection number if selected
                    Expanded(
                      child: Text(
                        option.text,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Container(
                  height: 5.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        Colors.grey[200], // Grey background for unfilled area
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: Stack(
                      children: [
                        // Only show filled area if total_vote_count > 0
                        if (total_vote_count > 0)
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: total_vote_count / 100,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${total_vote_count.toInt()}%',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            isSelected
                ? Container(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        '$selectionNumber',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.8),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

Widget _buildImagesStack(List images) {
  // Define alignments based on total image count
  List<Alignment> getAlignments(int totalImages) {
    switch (totalImages) {
      case 1:
        return [Alignment.center];
      case 2:
        return [Alignment.centerLeft, Alignment.centerRight];
      case 3:
        return [Alignment.centerLeft, Alignment.center, Alignment.centerRight];
      case 4:
      default:
        return [
          Alignment.centerLeft,
          Alignment.center,
          Alignment.centerRight,
          Alignment.centerRight
        ];
    }
  }

  List<Alignment> alignments = getAlignments(images.length);

  return LayoutBuilder(
    builder: (context, constraints) {
      // Get available width from GridView cell
      double availableWidth = constraints.maxWidth;
      double availableHeight = constraints.maxHeight;

      // Fixed height for images
      double imageHeight = 145.h; // Fixed height

      return SizedBox(
        height: availableHeight,
        width: availableWidth,
        child: Stack(
          children: images
              .asMap()
              .entries
              .map<Widget>((entry) {
                int index = entry.key;
                dynamic imageData = entry.value;

                // Get alignment for current index
                Alignment alignment = alignments[index];

                // Calculate width based on available GridView cell width
                double imageWidth = (availableWidth * 0.7) - (index * 8.0);

                // Ensure minimum width
                imageWidth = imageWidth < 60.w ? 60.w : imageWidth;

                return Align(
                  alignment: alignment,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: imageWidth,
                    height: imageHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9.r),
                        child: Image.network(
                          '${ApiConfig.baseUrlImage}${imageData.url}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[600],
                                size: 30,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              })
              .toList() // set image layer first to last
              .reversed
              .toList(), // Reverse the list so index[0] appears on top
        ),
      );
    },
  );
}
