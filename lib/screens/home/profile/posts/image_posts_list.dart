// ignore_for_file: must_be_immutable, deprecated_member_use, use_build_context_synchronously, unused_local_variable

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../api/api_config.dart';
import '../../../../api/services/api_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../models/posts/image/post_image_model.dart';
import '../../../../widgets/button/back_button.dart';
import '../../../../widgets/custom_text_styles.dart';
import '../../../../widgets/diolog/custom_diolog.dart';
import '../../../../widgets/loader.dart';
import '../../../../widgets/show_toast.dart';

class ImagePostsList extends StatefulWidget {
  String? username;
  ImagePostsList({super.key, required this.username});

  @override
  State<ImagePostsList> createState() => _ImagePostsListState();
}

class _ImagePostsListState extends State<ImagePostsList> {
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: PrimaryBackButton(),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.posts,
          style: CustomTextStyles.appBarTitleText(context),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
      ),
      body: FutureBuilder<List<PostImagesModel>>(
        future: apiService.fetchImagePosts(widget.username!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Loader(color: Theme.of(context).colorScheme.primary),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final postsImage = snapshot.data ?? [];
          if (postsImage.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.nopostsfound,
                style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
              ),
            );
          }

          return ListView.builder(
            itemCount: postsImage.length,
            itemBuilder: (context, index) {
              final imagePost = postsImage[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(10, 7.h, 10, 12.h),
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
                              imagePost.description, //  // Description
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            GestureDetector(
                              onTap: () {
                                showUserDeletePostDiolog(context, () {
                                  Navigator.pop(context);
                                  deletePost(imagePost.id, index, postsImage);
                                });
                              },
                              child: Icon(
                                FeatherIcons.moreVertical,
                                size: 16.spMax,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      if (imagePost.images.isNotEmpty) // Image
                        _buildImagesSection(context, imagePost.images),
                    ],
                  ),
                ),
              );
            },
          );
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
            child: SizedBox(
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
                      child: Loader(
                        color: Theme.of(context).colorScheme.primary,
                      ),
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
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
}
