// ignore_for_file: deprecated_member_use, unused_field, unused_local_variable
part of 'add_poll_import.dart';

class AddPollAnswer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddPollStateAnswer();
  }
}

class AddPollStateAnswer extends State<AddPollAnswer> with UtilityMixin {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  bool _isLoading = false;
  String questionErrorText = '';
  String optionsErrorText = '';

  final _dio = Dio();

  // Start with 1 default option fields
  final List<TextEditingController> optionControllers = [];

  // Add new options fields controller
  void addOptionField() {
    if (optionControllers.length < 4) {
      setState(() {
        optionControllers.add(
          TextEditingController(),
        );
      });
    }
  }

  Future<void> addPoll() async {
    final accessToken = await SharedPrefService.getAccessToken(); // ac_token
    final UserProvider provider = UserProvider();

    setState(() => _isLoading = true);

    final validOptions = optionControllers
        .where((controller) => controller.text.trim().isNotEmpty)
        .toList();

    if (questionController.text.trim().isEmpty) {
      if (!mounted) return;
      setState(() {
        questionErrorText = AppLocalizations.of(context)!.pleaseenteraquestion;
        _isLoading = false;
      });
      return;
    }

    if (validOptions.length < 2) {
      if (!mounted) return;
      setState(() {
        optionsErrorText =
            AppLocalizations.of(context)!.pleaseenteratleasttwooptions;
        _isLoading = false;
      });

      return;
    }

    var data = {
      "description": descriptionController.text,
      "polls": [
        {
          "question": questionController.text,
          "max_options": 4,
          "type": "text",
          "poll_options": optionControllers
              .map((controller) => {"text": controller.text})
              .toList(),
        }
      ]
    };

    try {
      final response = await _dio.post(
        ApiConstants.userPosts,
        data: data,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json"
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // print("RESPONSE : $response");
        showToast(message: 'New post created successfully!');
        navigationPush(
            context, UserThingsQuestionsList(username: provider.username!));
        if (!mounted) return;
        descriptionController.clear();
        questionController.clear();
        setState(() {
          optionControllers.clear();
          optionControllers.add(TextEditingController());
          optionControllers.add(TextEditingController());
          _isLoading = false;
        });

        descriptionController.clear();
        questionController.clear();
        for (var controller in optionControllers) {
          controller.clear();
        }
      }

      setState(() {
        optionControllers
          ..clear()
          ..addAll([]);
      });
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode ?? 0;
        if (statusCode == 400) {
          final errorData = e.response?.data;
          final errorMsg = errorData["errors"]?["poll"]?["options"] ??
              errorData["message"] ??
              "Validation failed";
          showToast(message: '${errorMsg}');
        } else {
          showToast(message: 'Error: ${e.response?.data}');
        }
      } else {
        showToast(message: 'Something went wrong: ${e.message}');
      }
    } catch (e) {
      showToast(message: 'Unexpected error: $e');
    } finally {
      setState(() => _isLoading = false);
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
        title: Text(AppLocalizations.of(context)!.addnewpollanswer,
            style: CustomTextStyles.appBarTitleText(context)),
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.question,
                style: CustomTextStyles.lblPrimaryText(context)),
            SizedBox(height: 7.h),
            SecondryTextfield(
                controller: questionController,
                hintText: AppLocalizations.of(context)!
                    .enteryouranswerhere), // Question
            if (questionErrorText.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Text(questionErrorText,
                    style: CustomTextStyles.msgErrorText),
              ),
            SizedBox(height: 10.h),
            Text(AppLocalizations.of(context)!.description,
                style: CustomTextStyles.lblPrimaryText(context)),
            SizedBox(height: 7.h),
            SecondryTextfield(
                controller: descriptionController,
                hintText: AppLocalizations.of(context)!
                    .enteryouranswerhere), // Description
            SizedBox(height: 5.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  optionControllers.length +
                      (optionControllers.length < 4 ? 1 : 0), (index) {
                if (index == optionControllers.length &&
                    optionControllers.length < 4) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: addOptionField,
                        icon: Icon(Icons.add,
                            color: Theme.of(context).colorScheme.primary),
                        label: Text(AppLocalizations.of(context)!.addoption),
                      ),
                      if (optionsErrorText.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 5.h),
                          child: Text(optionsErrorText,
                              style: CustomTextStyles.msgErrorText),
                        ),
                    ],
                  );
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 7.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${AppLocalizations.of(context)!.option} ${index + 1}',
                          style: CustomTextStyles.lblPrimaryText(context)),
                      SizedBox(height: 7),
                      SecondryTextfield(
                        controller: optionControllers[index],
                        hintText:
                            AppLocalizations.of(context)!.enteryouranswerhere,
                        suffixIcon: optionControllers.length > 2
                            ? IconButton(
                                icon: Icon(Icons.delete,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                onPressed: () {
                                  setState(() {
                                    optionControllers.removeAt(index);
                                  });
                                },
                              )
                            : null,
                      ), // Options
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 50.h,
        child: PrimaryButton(
            onPressed: addPoll,
            title: AppLocalizations.of(context)!.addpoll,
            isLoading: _isLoading),
      ),
    );
  }
}
