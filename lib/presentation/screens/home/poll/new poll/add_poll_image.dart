// ignore_for_file: deprecated_member_use, unused_field, unnecessary_null_comparison
part of 'add_poll_import.dart';

class AddPollImage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddPollStateImage();
  }
}

class AddPollStateImage extends State<AddPollImage> with UtilityMixin {
  final ApiService service = ApiService();
  final descriptionController = TextEditingController();

  String descriptionErrorText = '';
  String imageErrorText = '';
  bool isLoading = false;
  bool isUploading = false;
  double uploadProgress = 0.0;

  // List to store images dynamically
  List<File?> _images = [null, null]; // Start with one null image
  static const int maxImages = 4;


  void removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      if (_images.isEmpty) {
        _images.add(null);
      }
    });
  }

  void addImageSlot() {
    if (_images.length < maxImages) {
      setState(() {
        _images.add(null);
      });
    }
  }

  String _getOptionText(BuildContext context, int index) {
    // Method 1: Using a switch statement for predefined keys
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.option1;
      case 1:
        return AppLocalizations.of(context)!.option2;
      case 2:
        return AppLocalizations.of(context)!.option3;
      case 3:
        return AppLocalizations.of(context)!.option4;
      default:
        return 'Option ${index + 1}';
    }
  }

  void postImage() async {
    final accessToken = await SharedPrefService.getAccessToken();
    setState(() => isLoading = true);

    // Validate inputs
    if (descriptionController.text.trim().isEmpty) {
      if (!mounted) return;
      setState(() {
        descriptionErrorText =
            AppLocalizations.of(context)!.pleaseenteraquestion;
        isLoading = false;
      });
      return;
    }

    // Filter out null images
    List<File> selectedImages =
        _images.where((image) => image != null).cast<File>().toList();

    if (selectedImages.length < 0) {
      imageErrorText = AppLocalizations.of(context)!.pleaseenteratleastoneimage;
      setState(() => isLoading = false);
      return;
    }
    try {
      // Upload the poll
      Map<String, dynamic>? result = await ApiService.uploadPost(
        description: descriptionController.text.trim(),
        images: selectedImages,
        authToken: '$accessToken',
        onProgress: (progress) {
          setState(() {
            uploadProgress = progress;
          });
          print('Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
        },
      );

      setState(() => isLoading = true);

      if (result != null) {
        showToast(message: 'Poll created successfully!');
        setState(() => isLoading = false);
        // Navigate to success page or back
        descriptionController.clear();
        setState(() {
          _images = [null];
        });
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('too large')) {
        showToast(message: 'Image too large maximum size allowed is 10MB.');
      }
    } finally {
      setState(() {
        isLoading = false;
      });
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
        title: Text(AppLocalizations.of(context)!.addnewpollimage,
            style: CustomTextStyles.appBarTitleText(context)),
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        children: [
          Text(AppLocalizations.of(context)!.description,
              style: CustomTextStyles.lblPrimaryText(context)),
          SizedBox(height: 7.h),
          SecondryTextfield(
            controller: descriptionController,
            hintText: AppLocalizations.of(context)!.enteryouranswerhere,
            onChanged: (value) {
              // Clear error when user starts typing
              if (descriptionErrorText.isNotEmpty && value.trim().isNotEmpty) {
                setState(() {
                  descriptionErrorText = '';
                });
              }
            },
          ),
          if (descriptionErrorText.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Text(descriptionErrorText,
                  style: CustomTextStyles.msgErrorText),
            ),
          SizedBox(height: 20.h),
          // Dynamic image grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 15.h,
              // childAspectRatio: 1.0,
            ),
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  PrimaryImagePicker(
                    answer: _getOptionText(context, index),
                    onTap: () {},
                    image: _images[index],
                  ),
                  // Remove button - only show if there's more than 1 image slot
                  if (index > 0)
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => removeImage(index),
                        child: Container(
                          width: 20.w,
                          height: 20.h,
                          margin: EdgeInsets.only(right: 8.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 12.spMax,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          SizedBox(height: 15.h),
          // Add image button
          if (_images.length < maxImages)
            Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton.icon(
                    onPressed: addImageSlot,
                    label: Text(AppLocalizations.of(context)!.addimage),
                    icon: Icon(Icons.add,
                        color: Theme.of(context).colorScheme.primary)),
                if (imageErrorText.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 5.h),
                    child: Text(imageErrorText,
                        style: CustomTextStyles.msgErrorText),
                  ),
              ],
            )),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 50.h,
        child: PrimaryButton(
          title: AppLocalizations.of(context)!.addpoll,
          onPressed: postImage,
          isLoading: isLoading,
        ),
      ),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
