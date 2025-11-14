// ignore_for_file: unused_field, unused_element
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

import '../data/token/shared_preferences.dart';
import '../mixins/utility_mixins.dart';
import '../presentation/common widgets/show_toast.dart';
import '../presentation/screens/home/home_imports.dart';
import '../provider/user_provider.dart';
import 'model/public/images/public_profile_posts_model.dart';
import 'app_api.dart';
import 'model/home feed/home_feed_items_model.dart';
import 'model/posts/post_images_model.dart';
import 'model/posts/post_polls_model.dart';
import 'model/public/public_profile_model.dart';
import 'model/public/images/public_user_posts.dart';
import 'model/public/things/post_things_model.dart';
import 'model/search/search_user_model.dart';

class ApiService with UtilityMixin {
  final SharedPrefService _prefService = SharedPrefService();
  static final Dio _dio = Dio();

  // Initialize Dio with interceptors (optional)
  // static void initialize() {
  //   _dio.options.baseUrl = ApiConfig.baseUrl;
  //   _dio.options.connectTimeout = Duration(seconds: 50);
  //   _dio.options.receiveTimeout = Duration(seconds: 50);

  //   // Add interceptors for logging (optional)
  //   _dio.interceptors.add(LogInterceptor(
  //     requestBody: true,
  //     responseBody: true,
  //     logPrint: (obj) => print(obj),
  //   ));
  // }

  // Note: Implemented POST Method User Login
  Future<void> loginUser({
    required String email_username,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'username_or_email': email_username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        showToast(message: 'Login successful!');
        final String accessToken = response.data['access_token'] ?? '';
        final String refreshToken = response.data['refresh_token'] ?? '';
        _prefService.saveAccessToken(accessToken);
        _prefService.saveRefreshToken(refreshToken);
        Provider.of<UserProvider>(context, listen: false);
        //await userProvider.loadUserData();
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(microseconds: 200),
            child: HomeScreen(),
          ),
        );
      } else if (response.statusCode == 400) {
        showToast(message: 'Error : ${response.data['message']}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Server error: ${e.response?.data}');
      } else {
        print('Error : ${e.response?.data}');
        showToast(
            message:
                'An error occurred. Please try again later : ${e.response?.data}');
      }
    }
  }

  // Note: Implemented GET Userdata Method
  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      final accessToken = await SharedPrefService.getAccessToken(); // ac_token
      if (accessToken == null || accessToken.isEmpty) {
        return null;
      }
      final response = await _dio.get(
        ApiConstants.userProfile,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        // print('API call failed with status: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      // print('DioException in fetchUserData: ${e.message}');
      if (e.response != null) {
        // print('Server error: ${e.response?.data}');
      }
      return null;
    } catch (e) {
      // print('Unexpected error in fetchUserData: $e');
      return null;
    }
  }

  // Note: Implemented POST Method User Update Profile
  Future<String> updateProfile({
    required String firstNmame,
    required String lastName,
    required String bio,
    required String dob,
    String? gender,
  }) async {
    final accessToken = await SharedPrefService.getAccessToken();
    try {
      final response = await _dio.patch(ApiConstants.updateProfile,
          data: {
            'first_name': firstNmame,
            'last_name': lastName,
            'bio': bio,
            'dob': dob,
            if (gender != null) 'gender': gender,
          },
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      print(response);
      if (response.statusCode == 200) {
        showToast(message: 'Profile updated successfully!');

        return 'Profile updated successfully!';
      } else if (response.statusCode == 400) {
        showToast(message: '${response.data['message']}');
        return response.data['message'] ?? 'Failed to update profile';
      } else {
        showToast(message: 'Failed to update profile');
        return 'Failed to update profile';
      }
    } catch (e) {
      showToast(message: 'Failed to update profile');
      return 'An unexpected error occurred';
    }
  }

  // Note: Implemented POST Method User Update Username
  Future<String> updateUsername({
    required String newUsername,
  }) async {
    final accessToken = await SharedPrefService.getAccessToken();
    try {
      final response = await _dio.post(ApiConstants.updateUsername,
          data: {
            'new_username': newUsername,
          },
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      if (response.statusCode == 200) {
        showToast(message: 'Username updated successfully!');

        return ''; // Return empty string for success
      } else {
        return 'Failed to update username';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        String errorMessage = '${e.response?.data['message']}.';
        print('Error Status: ${e.response?.statusCode}');

        return errorMessage;
      } else {
        print('Dio error: ${e.message}');
        return 'Network error occurred';
      }
    } catch (e) {
      print('Unexpected error: $e');
      return 'An unexpected error occurred';
    }
  }

  // Note: Implemented PUT Method User Profile Image
  Future<String> uploadProfileImage(File file) async {
    final accessToken = await SharedPrefService.getAccessToken();
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'profile_picture': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });
      final response = await _dio.put(
        ApiConstants.profileImage,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      if (response.statusCode == 200) {
        return '';
      } else if (response.statusCode == 413) {
        return 'Image too large maximum size allowed is 10MB.';
      } else {
        return 'Failed to upload profile photo!';
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 413) {
        return 'Image too large maximum size allowed is 10MB.';
      }
      return 'Image Upload failed';
    } catch (e) {
      return 'Unexpected error';
    }
  }

  // Note: Implemented PUT Method User Cover Image
  Future<String> uploadCoverPhoto(File file) async {
    final accessToken = await SharedPrefService.getAccessToken();
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'cover_photo': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });
      final response = await _dio.put(
        ApiConstants.coverImage,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      if (response.statusCode == 200) {
        return '';
      } else if (response.statusCode == 413) {
        return 'Image too large maximum size allowed is 10MB.';
      } else {
        return 'Failed to upload cover photo!';
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 413) {
        return 'Image too large maximum size allowed is 10MB.';
      }
      return 'Image Upload failed';
    } catch (e) {
      return 'Unexpected error';
    }
  }

  // Note: Implemented POST Method User Update Password
  Future<String> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
    required void Function(String? currentPasswordError,
            String? newPasswordError, String? confirmPasswordError)
        onError,
  }) async {
    final accessToken = await SharedPrefService.getAccessToken();
    try {
      final response = await _dio.post(ApiConstants.updatePassword,
          data: {
            'current_password': currentPassword,
            'new_password': newPassword,
            'confirm_new_password': confirmNewPassword,
          },
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      if (response.statusCode == 200) {
        showToast(message: 'Password updated successfully!');
        return '';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 400) {
          final errors = e.response?.data['errors'];
          final currentPasswordError = errors?['current_password']?.first;
          final newPasswordError = errors?['new_password']?.first;
          final confirmPasswordError = errors?['confirm_new_password']?.first;
          onError(currentPasswordError, newPasswordError, confirmPasswordError);
          return errors.toString();
        } else {
          print("⚠️ Server Error: ${e.response?.statusCode}");
          return 'Failed to update password!';
        }
      } else {
        print("⚠️ Request failed: ${e.message}");
        return 'An unexpected error occurred!';
      }
    }
    return 'Failed to update password!'; // Ensure all code paths return a String
  }

  // Note: Implemented GET Method User Search
  Future<List<SearchUserModel>> searchUsers(String query) async {
    final accessToken = await SharedPrefService.getAccessToken();
    try {
      final response = await _dio.get(ApiConstants.searchUsers,
          queryParameters: {'q': query},
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final results = response.data['data']['results'] as List;
        return results.map((e) => SearchUserModel.fromJson(e)).toList();
      } else if (response.statusCode == 400) {
        final errorMsg = response.data['message'] ?? 'Bad request';
        showToast(message: errorMsg);
        throw Exception('400 Error: $errorMsg');
      } else {
        throw Exception("Failed to fetch users");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Note: Implemented POST Method User Send Friend Request
  Future<bool> sendFriendRequest(String username) async {
    final accessToken = await SharedPrefService.getAccessToken();
    try {
      final response = await _dio.post(
        ApiConstants.sendRequest,
        data: {'receiver_username': username},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      print(response);
      if (response.statusCode == 201 && response.data['status'] == 'success') {
        showToast(message: 'Friend request sent!');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print('Error sending friend request: $e');
      return false;
    }
  }

  static Future<List<HomeFeedPost>> fetchHomeFeedPosts() async {
    final accessToken = await SharedPrefService.getAccessToken();
    try {
      final response = await _dio.get(
        ApiConstants.homeFeed,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // ✅ CORRECT: Parse as Map first
        final Map<String, dynamic> jsonData =
            response.data as Map<String, dynamic>;

        // Parse the full response
        final homeFeedResponse = HomeFeedResponse.fromJson(jsonData);

        // Return the posts array
        return homeFeedResponse.results;
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Detailed error: $e');
      throw Exception('Error fetching posts: $e');
    }
  }

  // Note: Implemented GET Method User Post Feed
  Future<List<PostPolls>> fetchPostsPolls(String username) async {
    try {
      final response = await _dio.get("${ApiConstants.userPosts}/$username");

      // Extract the 'results' array from the paginated response
      final List<dynamic> data = response.data['results'] as List<dynamic>;
      print('POSTS : $data');
      return data.map((e) => PostPolls.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching posts: $e');
      rethrow;
    }
  }

// Add this method to get only posts with polls
  Future<List<PostPolls>> fetchOnlyPollPosts(String username) async {
    final allPosts = await fetchPostsPolls(username);
    // Filter out posts that have empty polls array
    return allPosts.where((post) => post.polls.isNotEmpty).toList();
  }

  // Note: Implemented GET Method User Post Images
  Future<List<PostImagesModel>> fetchPostsImages(String username) async {
    try {
      final response = await _dio.get("${ApiConstants.userPosts}/$username");
      final List<dynamic> data = response.data;
      return data.map((e) => PostImagesModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PostImagesModel>> fetchImagePosts(String username) async {
    final allPosts = await fetchPostsImages(username);
    return allPosts.where((p) => p.images.isNotEmpty).toList();
  }

  // Method to upload post with loading states
  static Future<Map<String, dynamic>?> uploadPost({
    required String description,
    required List<File> images,
    String? authToken,
    Function(double)? onProgress, // Progress callback
    maxFileSizeMB = 4, // 4MB per file
    maxTotalSizeMB = 12, // 12MB total
  }) async {
    try {
      // Create FormData with progress tracking
      FormData formData = FormData();
      formData.fields.add(MapEntry('description', description));

      // Add images with progress tracking
      for (int i = 0; i < images.length; i++) {
        File imageFile = images[i];
        String fileName = path.basename(imageFile.path);

        MultipartFile multipartFile = await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        );

        formData.files.add(MapEntry('images', multipartFile));
      }

      // Set headers
      Map<String, dynamic> headers = {
        'Content-Type': 'multipart/form-data',
      };

      if (authToken != null) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      // Make request with progress tracking
      Response response = await ApiService._dio.post(
        ApiConstants.userPosts,
        data: formData,
        options: Options(headers: headers),
        onSendProgress: (sent, total) {
          if (onProgress != null && total != -1) {
            double progress = sent / total;
            onProgress(progress);
          }
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to upload post');
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 413) {
        showToast(message: 'Image too large maximum size allowed is 10MB.');
      }
    }
    return null;
  }

  // Note: Implemented DELETE Method User Delete Post
  Future<bool> userDeletePost(int postId) async {
    final accessToken = await SharedPrefService.getAccessToken();

    try {
      final response = await _dio.delete(
        "${ApiConstants.deletePost}/$postId/delete",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete post: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error deleting post: $error');
    }
  }

  // Note: Implemented GET Method User Followers List
  Future<List<Map<String, dynamic>>> getFollowersList() async {
    final accessToken = await SharedPrefService.getAccessToken();
    try {
      final response = await _dio.get(
        ApiConstants.followersList,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        List<dynamic> data = response.data['data'];
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load following list');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.response?.data}');
      rethrow;
    }
  }

  // Note: Implemented GET Method User Following List
  Future<List<Map<String, dynamic>>> getFollowingList() async {
    final accessToken = await SharedPrefService.getAccessToken();
    try {
      final response = await _dio.get(
        ApiConstants.followingList,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        List<dynamic> data = response.data['data'];
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load following list');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.response?.data}');
      rethrow;
    }
  }

  // Note: Implemented GET Method User Public Profile
  static Future<PublicProfileModel> getUserPublicProfile(int userId) async {
    final accessToken = await SharedPrefService.getAccessToken();
    try {
      final response = await _dio.get(
        "${ApiConstants.publicProfile}/$userId/profile",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final publicData = response.data;

        if (publicData['status'] == 'success') {
          return PublicProfileModel.fromJson(publicData);
        } else {
          throw Exception('API returned error: ${publicData['message']}');
        }
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

// Note: Implemented GET Method User Public Profile Posts
  Future<PublicProfileModel?> getPublicProfilePosts(int userId) async {
    try {
      final response =
          await _dio.get('${ApiConstants.userPosts}/users/$userId/profile');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return PublicProfileModel.fromJson(response.data['data']);
      } else {
        print('API Error: ${response.data['message'] ?? 'Unknown error'}');
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {}
      return null;
    } catch (e) {
      // print('Unexpected Error: $e');
      return null;
    }
  }

  Future<UserPublicProfile> getPublicPosts(int userId) async {
    final accessToken = await SharedPrefService.getAccessToken();
    try {
      final response = await _dio.get(
        '${ApiConstants.publicProfile}/$userId/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData['status'] == 'success') {
          return UserPublicProfile.fromJson(jsonData['data']);
        } else {
          throw Exception('API Error: ${jsonData['message']}');
        }
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<PublicPost>> fetchPostsWithImages(int userId) async {
    final userPublicProfileImage = await getPublicPosts(userId);
    return userPublicProfileImage.posts
        .where((post) => post.images.isNotEmpty)
        .toList();
  }

  Future<List<PublicPostPolls>> fetchPublicPostsPolls(int userId) async {
    final accessToken = await SharedPrefService.getAccessToken();
    try {
      final response = await _dio.get(
        '${ApiConstants.publicProfile}/$userId/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );
      final Map<String, dynamic> responseData = response.data;
      final List<dynamic> posts = responseData['data']['posts'] ?? [];
      return posts.map((post) => PublicPostPolls.fromJson(post)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
