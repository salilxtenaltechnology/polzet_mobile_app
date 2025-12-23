// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../api/app_api.dart';
import '../../../data/token/shared_preferences.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../mixin/utility_mixins.dart';
import '../../../provider/user_provider.dart';
import '../../../widgets/button/back_button.dart';
import '../../../widgets/button/primary_button.dart';
import '../../../widgets/custom_text_styles.dart';
import '../../../widgets/show_toast.dart';
import '../../../widgets/text_field/secondry_textfield.dart';
import '../profile/posts/questions_posts_list.dart';

class PollQuestion extends StatefulWidget {
  const PollQuestion({super.key});

  @override
  State<PollQuestion> createState() => _PollQuestionState();
}

class _PollQuestionState extends State<PollQuestion> with UtilityMixin {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  bool _isLoading = false;
  String questionErrorText = '';
  String optionsErrorText = '';

  final _dio = Dio();

  // List of option controllers
  final List<TextEditingController> optionControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize with 2 default option fields
    optionControllers.add(TextEditingController());
    optionControllers.add(TextEditingController());

    // Add listeners to clear error when user types
    for (var controller in optionControllers) {
      controller.addListener(_clearOptionsError);
    }
    questionController.addListener(_clearQuestionError);
  }

  void _clearQuestionError() {
    if (questionErrorText.isNotEmpty &&
        questionController.text.trim().isNotEmpty) {
      setState(() {
        questionErrorText = '';
      });
    }
  }

  void _clearOptionsError() {
    if (optionsErrorText.isNotEmpty) {
      final validCount = optionControllers
          .where((controller) => controller.text.trim().isNotEmpty)
          .length;
      if (validCount >= 2) {
        setState(() {
          optionsErrorText = '';
        });
      }
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    questionController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Add new options fields controller
  void addOptionField() {
    if (optionControllers.length < 4) {
      setState(() {
        final newController = TextEditingController();
        newController.addListener(_clearOptionsError);
        optionControllers.add(newController);
      });
    }
  }

  // Remove option field
  void removeOptionField(int index) {
    if (optionControllers.length > 2) {
      setState(() {
        optionControllers[index].dispose();
        optionControllers.removeAt(index);
      });
    }
  }

  Future<void> addPoll() async {
  final accessToken = await SharedPrefService.getAccessToken();
  final UserProvider provider = UserProvider();

  // Clear previous errors first
  setState(() {
    questionErrorText = '';
    optionsErrorText = '';
  });

  // Collect valid options
  final validOptions = optionControllers
      .where((controller) => controller.text.trim().isNotEmpty)
      .map((controller) => controller.text.trim())
      .toList();

  // Validation
  bool hasError = false;

  if (questionController.text.trim().isEmpty) {
    setState(() {
      questionErrorText = AppLocalizations.of(context)!.pleaseenteraquestion;
    });
    hasError = true;
  }

  if (validOptions.length < 2) {
    setState(() {
      optionsErrorText = AppLocalizations.of(
        context,
      )!.pleaseenteratleasttwooptions;
    });
    hasError = true;
  }

  // Debug print
  if (kDebugMode) {
    print('Valid options count: ${validOptions.length}');
    print('Valid options: $validOptions');
    print('Has error: $hasError');
  }

  if (hasError) {
    return;
  }

  // Now set loading after validation passes
  setState(() {
    _isLoading = true;
  });

  // Prepare data - matching the Postman structure
  var data = {
    "description": descriptionController.text.trim(),
    "question": questionController.text.trim(),
    "max_options": 4,
    "poll_options": validOptions, // Just array of strings
  };

  try {
    final response = await _dio.post(
      ApiConstants.userPosts,
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (!mounted) return;

      showToast(message: 'New post created successfully!');

      // Clear fields
      descriptionController.clear();
      questionController.clear();
      for (var controller in optionControllers) {
        controller.removeListener(_clearOptionsError);
        controller.dispose();
      }

      // Reset to initial state with 2 empty options
      setState(() {
        optionControllers.clear();
        final controller1 = TextEditingController();
        final controller2 = TextEditingController();
        controller1.addListener(_clearOptionsError);
        controller2.addListener(_clearOptionsError);
        optionControllers.add(controller1);
        optionControllers.add(controller2);
        _isLoading = false;
        questionErrorText = '';
        optionsErrorText = '';
      });

      if (kDebugMode) {
        print('Post created: ${response.data}');
      }

      // Navigate to posts list
      navigationPush(
        context,
        QuestionsPostsList(username: provider.username),
      );
    }
  } on DioException catch (e) {
    if (!mounted) return;

    if (e.response != null) {
      final statusCode = e.response?.statusCode ?? 0;
      final errorData = e.response?.data;

      String errorMsg;
      if (statusCode == 400) {
        // Try to extract meaningful error message
        errorMsg =
            errorData?["errors"]?["poll_options"]?.toString() ??
            errorData?["errors"]?["question"]?.toString() ??
            errorData?["message"]?.toString() ??
            "Validation failed";
      } else if (statusCode == 401) {
        errorMsg = "Unauthorized. Please login again.";
      } else {
        errorMsg =
            errorData?["message"]?.toString() ??
            'Error: ${e.response?.statusMessage}';
      }

      showToast(message: errorMsg);
    } else {
      showToast(message: 'Connection error: ${e.message}');
    }
  } catch (e) {
    if (!mounted) return;
    showToast(message: 'Unexpected error: $e');
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
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
          AppLocalizations.of(context)!.addnewpollanswer,
          style: CustomTextStyles.appBarTitleText(context),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(
              AppLocalizations.of(context)!.question,
              style: CustomTextStyles.lblPrimaryText(context),
            ),
            SizedBox(height: 7.h),
            SecondryTextfield(
              controller: questionController,
              hintText: AppLocalizations.of(context)!.enteryouranswerhere,
            ),
            if (questionErrorText.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Text(
                  questionErrorText,
                  style: CustomTextStyles.msgErrorText,
                ),
              ),
            SizedBox(height: 15.h),
            Text(
              AppLocalizations.of(context)!.description,
              style: CustomTextStyles.lblPrimaryText(context),
            ),
            SizedBox(height: 7.h),
            SecondryTextfield(
              controller: descriptionController,
              hintText: AppLocalizations.of(context)!.enteryouranswerhere,
            ),
            SizedBox(height: 15.h),
            // Options Section
            Text(
              'Poll Options',
              style: CustomTextStyles.lblPrimaryText(context),
            ),
            SizedBox(height: 10.h),
            // Render existing option fields
            ...List.generate(optionControllers.length, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.option} ${index + 1}',
                      style: CustomTextStyles.lblPrimaryText(context),
                    ),
                    SizedBox(height: 7.h),
                    SecondryTextfield(
                      controller: optionControllers[index],
                      hintText: AppLocalizations.of(
                        context,
                      )!.enteryouranswerhere,
                      suffixIcon: optionControllers.length > 2
                          ? IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () => removeOptionField(index),
                            )
                          : null,
                    ),
                  ],
                ),
              );
            }),
            // Add Option Button
            if (optionControllers.length < 4)
              TextButton.icon(
                onPressed: addOptionField,
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: Text(
                  AppLocalizations.of(context)!.addoption,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            if (optionsErrorText.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 5.h, bottom: 10.h),
                child: Text(
                  optionsErrorText,
                  style: CustomTextStyles.msgErrorText,
                ),
              ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 50.h,
        child: PrimaryButton(
          onPressed: addPoll,
          title: AppLocalizations.of(context)!.addpoll,
          isLoading: _isLoading,
        ),
      ),
    );
  }
}
