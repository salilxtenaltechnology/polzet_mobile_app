// ignore_for_file: deprecated_member_use, must_be_immutable, unused_element

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../api/api_config.dart';
import '../../../../api/api_service.dart';
import '../../../../api/model/posts/post_images_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common widgets/button/back_button.dart';
import '../../../common widgets/custom_text_styles.dart';
import '../../../common widgets/diolog/custom_diolog.dart';
import '../../../common widgets/loader.dart';
import '../../../common widgets/show_toast.dart';

class UserImagePosts extends StatefulWidget {
  String? username;
  UserImagePosts({super.key, required this.username});

  @override
  State<UserImagePosts> createState() => _PostImagesState();
}

class _PostImagesState extends State<UserImagePosts> {
  late final ApiService apiService = ApiService();

  Future<void> deletePost(int postId, int index, List posts) async {
    try {
      // Call the API to delete
      bool success = await apiService.userDeletePost(postId);
      if (success) {
        // Remove from UI after successful API call
        setState(() {
          posts.removeAt(index);
        });

        showToast(message: 'Post deleted successfully');
      } else {
        showToast(message: 'Failed to delete post');
      }
    } catch (error) {
      // Close loading dialog
      Navigator.of(context).pop();
      showToast(message: 'Error: ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: PrimaryBackButton(),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.posts,
            style: CustomTextStyles.appBarTitleText(context)),
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
      ),
      body: FutureBuilder<List<PostImagesModel>>(
        future: apiService.fetchImagePosts(widget.username!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Loader(color: Theme.of(context).colorScheme.primary));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final postsImage = snapshot.data ?? [];
          if (postsImage.isEmpty)
            return Center(
                child: Text(
              AppLocalizations.of(context)!.nopostsfound,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.sp,
              ),
            ));

          return ListView.builder(
              itemCount: postsImage.length,
              itemBuilder: (context, index) {
                final image_post = postsImage[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(0, 7.h, 0, 12.h),
                  child: Container(
                    padding: EdgeInsets.only(top: 5.h, bottom: 10.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(20, 0, 0, 0),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                image_post.description, //  // Description
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    showUserDeletePostDiolog(context, () {
                                      Navigator.pop(context);
                                      deletePost(
                                          image_post.id, index, postsImage);
                                    });
                                  },
                                  child: Icon(FeatherIcons.moreVertical,
                                      size: 16.spMax))
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        if (image_post.images.isNotEmpty) // Image
                          _buildImagesSection(context, image_post.images),
                        //  _buildImagesStack(image_post.images),
                        SizedBox(height: 7.w),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Row(
                            children: [
                              Icon(FeatherIcons.heart),
                              SizedBox(width: 11.w),
                              Icon(FeatherIcons.messageSquare),
                              SizedBox(width: 11.w),
                              Icon(FeatherIcons.send)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  Widget _buildImagesSection(BuildContext context, List images) {
    if (images.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 200,
              width: double.infinity,
              child: Image.network(
                '${ApiConfig.baseUrlImage}${images[0].url}',
                height: 150.h,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150.h,
                    color: Colors.grey[200],
                    child: Center(
                      child:
                          Loader(color: Theme.of(context).colorScheme.primary),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    } else if (images.length == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    '${ApiConfig.baseUrlImage}${images[0].url}',
                    height: 150.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150.h,
                        color: Colors.grey[200],
                        child: Center(
                          child: Loader(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    '${ApiConfig.baseUrlImage}${images[1].url}',
                    height: 150.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150.h,
                        color: Colors.grey[300],
                        child: Center(
                          child: Loader(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (images.length == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    '${ApiConfig.baseUrlImage}${images[0].url}',
                    height: 150.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150.h,
                        color: Colors.grey[200],
                        child: Center(
                          child: Loader(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    '${ApiConfig.baseUrlImage}${images[1].url}',
                    height: 150.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150.h,
                        color: Colors.grey[300],
                        child: Center(
                          child: Loader(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    '${ApiConfig.baseUrlImage}${images[2].url}',
                    height: 150.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150.h,
                        color: Colors.grey[300],
                        child: Center(
                          child: Loader(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (images.length == 4) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Row
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    '${ApiConfig.baseUrlImage}${images[0].url}',
                    height: 150.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150.h,
                        color: Colors.grey[200],
                        child: Center(
                          child: Loader(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150.h,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    '${ApiConfig.baseUrlImage}${images[1].url}',
                    height: 150.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150.h,
                        color: Colors.grey[300],
                        child: Center(
                          child: Loader(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150.h,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.w),
          // Second Row
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    '${ApiConfig.baseUrlImage}${images[2].url}',
                    height: 150.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150.h,
                        color: Colors.grey[200],
                        child: Center(
                          child: Loader(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150.h,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    '${ApiConfig.baseUrlImage}${images[3].url}',
                    height: 150.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150.h,
                        color: Colors.grey[300],
                        child: Center(
                          child: Loader(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150.h,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

// Images stack method - single image or stacked images
  Widget _buildImagesStack(List images) {
    // Define alignments based on total image count
    List<Alignment> getAlignments(int totalImages) {
      switch (totalImages) {
        case 1:
          return [Alignment.center];
        case 2:
          return [Alignment.centerLeft, Alignment.centerRight];
        case 3:
          return [
            Alignment.centerLeft,
            Alignment.center,
            Alignment.centerRight
          ];
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

    return SizedBox(
      height: 170.h,
      width: double.infinity,
      child: Stack(
        children: images
            .asMap()
            .entries
            .map<Widget>((entry) {
              int index = entry.key;
              dynamic imageData = entry.value;

              // Get alignment for current index
              Alignment alignment = alignments[index];

              // Calculate responsive dimensions
              double deviceWidth = MediaQuery.of(context).size.width;
              double imageWidth = deviceWidth * 0.6 -
                  (index * 10.0); // 75% of device width, decreasing

              return Align(
                alignment: alignment,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  width: imageWidth,
                  height: 170.h,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.r),
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
                              size: 40,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
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
            .toList()
            .reversed
            .toList(), // Reverse the list so index[0] appears on top
      ),
    );
  }
}
