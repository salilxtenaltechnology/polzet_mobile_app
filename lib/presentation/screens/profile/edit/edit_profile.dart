// ignore_for_file: deprecated_member_use, unused_field, unused_element
part of '../user_profile_import.dart';

// =====================
// EditProfile Widget
// =====================
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> with UtilityMixin {
  // =====================
  // Controllers
  // =====================
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _dobController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // =====================
  // State Variables
  // =====================
  final ApiService apiService = ApiService();
  var dio = Dio();

  String _initialFirstName = "";
  String _initialLastName = "";
  String _initialUsername = "";
  String initialCoverImage = "";
  String initialProfileImage = "";
  String _initialDateOfBirth = "";
  String _initialGender = "Other";
  String _initialBio = "";
  String _initialEmail = "";
  String _initialPhonenumber = "";
  String _initialCountryCode = "";
  String _initialCurrentPassword = "";
  String _initialNewPassword = "";
  String _initialConfirmPassword = "";
  String _selectedGender = 'Other';
  String _passwordErrorText = '';
  String _profileErrorText = '';
  String _usernameErrorText = '';
  String? currentPasswordErrorText;
  String? newPasswordErrorText;
  String? confirmPasswordErrorText;
  String? _countryCode;

  File? coverImage;
  File? profileImage;
  bool _showUpdateProfileButton = false;
  bool _showUpdateUsernameButton = false;
  bool _showUpdatePasswordButton = false;
  bool _isLoading = false;
  bool _isSaveProfile = false;
  bool _isSaveUsername = false;
  bool _isSavePassword = false;
  bool _isCurrentPasswordHidden = true;
  bool _isNewPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  bool _isUploadingCover = false;
  bool _isUploadingProfile = false;

  List<String> genderOptions = ['Male', 'Female', 'Other'];

  // Helper method to convert gender to proper case
  String _formatGender(String gender) {
    if (gender.isEmpty) return 'Other';
    return gender[0].toUpperCase() + gender.substring(1).toLowerCase();
  }

  // Helper method to get display gender from stored value
  String _getDisplayGender(String storedGender) {
    switch (storedGender.toLowerCase()) {
      case 'male':
        return 'Male';
      case 'female':
        return 'Female';
      case 'other':
        return 'Other';
      default:
        return 'Other';
    }
  }

  // =====================
  // Lifecycle Methods
  // =====================
  @override
  void initState() {
    super.initState();
    getUserProfile();

    _firstNameController.text = _initialFirstName;
    _lastNameController.text = _initialLastName;
    _usernameController.text = _initialUsername;
    _bioController.text = _initialBio;
    _emailController.text = _initialEmail;
    _phoneNumberController.text = _initialPhonenumber;
    _countryCode = _initialCountryCode;
    _dobController.text = _initialDateOfBirth;
    _selectedGender = _initialGender;
    _showUpdateProfileButton = false;
    _showUpdatePasswordButton = false;
    _showUpdateUsernameButton = false;

    _firstNameController.addListener(() {
      checkIfChangedProfile(_firstNameController.text, _initialFirstName);
    });

    _lastNameController.addListener(() {
      checkIfChangedProfile(_lastNameController.text, _initialLastName);
    });

    _bioController.addListener(() {
      checkIfChangedProfile(_bioController.text, _initialBio);
    });

    _usernameController.addListener(() {
      checkIfChangedUsername(_usernameController.text, _initialUsername);
    });

    _dobController.addListener(() {
      checkIfChangedProfile(_dobController.text, _initialDateOfBirth);
    });

    _currentPasswordController.addListener(() {
      checkIfChangedPassword(
          _currentPasswordController.text, _initialCurrentPassword);
    });

    _newPasswordController.addListener(() {
      checkIfChangedPassword(_newPasswordController.text, _initialNewPassword);
    });

    _confirmPasswordController.addListener(() {
      checkIfChangedPassword(
          _confirmPasswordController.text, _initialConfirmPassword);
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _dobController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _countryCode = null;
    _phoneNumberController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // =====================
  // API Calls & Data Loaders
  // =====================
  Future<void> getUserProfile() async {
    final accessToken = await SharedPrefService.getAccessToken();
    var dio = Dio();

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await dio.get(ApiConstants.userProfile,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          ));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        setState(() {
          _firstNameController.text = data['first_name'] ?? '';
          _initialFirstName = data['first_name'] ?? '';
          _lastNameController.text = data['last_name'] ?? '';
          _initialLastName = data['last_name'] ?? '';
          _usernameController.text = data['username'] ?? '';
          _initialUsername = data['username'] ?? '';
          initialCoverImage = data['profile_picture_url'] ?? '';
          _dobController.text = data['dob'] ?? '';
          _initialDateOfBirth = data['dob'] ?? '';
          _selectedGender = _getDisplayGender(data['gender'] ?? 'Other');
          _initialGender = _getDisplayGender(data['gender'] ?? 'Other');
          _bioController.text = data['bio'] ?? '';
          _initialBio = data['bio'] ?? '';
          _emailController.text = data['email'] ?? '';
          _initialEmail = data['email'] ?? '';
          _countryCode = data['country_code']?.replaceAll('+', '') ?? '91';
          _initialCountryCode =
              data['country_code']?.replaceAll('+', '') ?? '91';
          _phoneNumberController.text = data['mobile_number'] ?? '';
          _initialPhonenumber = data['mobile_number'] ?? '';
        });
      }
      //showToast(message: 'Profile Fetched');
    } catch (e) {
      print('Error fetching user profile: $e');
      return;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // =====================
  // Utility Methods
  // =====================

  void checkIfChangedProfile(String current, String initial) {
    if (!_isLoading) {
      setState(() {
        _showUpdateProfileButton =
            _firstNameController.text != _initialFirstName ||
                _lastNameController.text != _initialLastName ||
                _bioController.text != _initialBio ||
                _dobController.text != _initialDateOfBirth ||
                _selectedGender != _initialGender;
      });
    }
  }

  void checkIfChangedUsername(String current, String initial) {
    if (!_isLoading) {
      setState(() {
        _showUpdateUsernameButton = current != initial;
      });
    }
  }

  void checkIfChangedPassword(String current, String initial) {
    if (!_isLoading) {
      setState(() {
        _showUpdatePasswordButton = current != initial;
      });
    }
  }

  // =====================
  // Profile & Password Update Methods
  // =====================
  void updateProfile() async {
    setState(() {
      _initialFirstName = _firstNameController.text;
      _initialLastName = _lastNameController.text;
      _initialBio = _bioController.text;
      _initialDateOfBirth = _dobController.text;
      _initialGender = _selectedGender;
      _showUpdateProfileButton = true;
    });

    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String bio = _bioController.text.trim();
    String dob = _dobController.text;
    if (!mounted) return;
    setState(() => _isSaveProfile = true);

    String errorMessage = await apiService.updateProfile(
      firstNmame: firstName,
      lastName: lastName,
      bio: bio,
      dob: dob,
      gender: _selectedGender.toLowerCase(),
    );

    if (!mounted) return;
    if (errorMessage.isNotEmpty) {
      setState(() {
        _profileErrorText = errorMessage;
        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _showUpdateProfileButton = false;
          });
        });
      });
    } else {
      setState(() {
        _profileErrorText = '';
      });
    }

    if (!mounted) return;
    setState(() => _isSaveProfile = false);
  }

  void changeUsername() async {
    setState(() {
      _initialUsername = _usernameController.text;
      _showUpdateUsernameButton = true;
    });
    String username = _usernameController.text.trim();

    if (!mounted) return;
    setState(() => _isSaveUsername = true);

    if (username.isEmpty) {
      if (!mounted) return;
      setState(() {
        _usernameErrorText = 'Username is required';
      });
      return;
    }

    String errorMessage = await apiService.updateUsername(
      newUsername: username,
    );

    if (!mounted) return;
    if (errorMessage.isNotEmpty) {
      setState(() {
        _usernameErrorText = errorMessage;
        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _showUpdateUsernameButton = false;
          });
        });
      });
    } else {
      setState(() {
        _usernameErrorText = '';
      });
    }

    if (!mounted) return;
    setState(() => _isSaveUsername = false);
  }

  void updatePassword() async {
    setState(() {
      _initialCurrentPassword = _currentPasswordController.text;
      _initialNewPassword = _newPasswordController.text;
      _initialConfirmPassword = _confirmPasswordController.text;
      _showUpdatePasswordButton = true;
    });

    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(newPassword)) {
      if (!mounted) return;
      setState(() {
        newPasswordErrorText =
            'Password must be at least 8 characters long and include one uppercase letter and one special character.';
        _isLoading = false;
      });
      return;
    }

    if (!mounted) return;
    setState(() => _isSavePassword = true);

    String result = await apiService.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmPassword,
      onError: (currentPasswordError, newPasswordError, confirmPasswordError) {
        setState(() {
          currentPasswordErrorText = currentPasswordError;
          newPasswordErrorText = newPasswordError;
          confirmPasswordErrorText = confirmPasswordError;
        });
      },
    );

    if (!mounted) return;

    // Check if password update was successful (empty string means success)
    if (result.isEmpty) {
      // Clear all password controllers on success
      setState(() {
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        _initialCurrentPassword = '';
        _initialNewPassword = '';
        _initialConfirmPassword = '';
        _showUpdatePasswordButton = false;
        // Clear any error messages
        currentPasswordErrorText = null;
        newPasswordErrorText = null;
        confirmPasswordErrorText = null;
        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _showUpdatePasswordButton = false;
          });
        });
      });
    }

    setState(() {
      _isSavePassword = false;
    });
  }

// Alternative version with more flexible cropping options
  Future<File?> _cropImageFlexible(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true, // Allow free cropping
          hideBottomControls: false,
          toolbarWidgetColor: AppColors.primaryColor,
          activeControlsWidgetColor: AppColors.primaryColor,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.ratio7x5
          ],
        ),
        IOSUiSettings(
          title: 'Crop Cover Photo',
          aspectRatioLockEnabled: false,
          resetAspectRatioEnabled: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  Future<void> uploadCoverPhoto(BuildContext context, File file) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String result = await apiService.uploadCoverPhoto(file);
    if (result.isEmpty) {
      showToast(message: 'Cover photo uploaded successfully!');
      await userProvider.loadUserData(); // Refresh provider
    } else {
      showToast(message: result);
      if (result.contains('too large')) {
        if (mounted) {
          setState(() {
            coverImage = null;
            _isUploadingCover = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            coverImage = null;
            _isUploadingCover = false;
          });
        }
      }
    }
  }

  // =====================
  // Date Picker
  // =====================
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      keyboardType: TextInputType.numberWithOptions(),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
            data: ThemeData(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryColor,
              ),
              dialogBackgroundColor: AppColors.primaryColor.withOpacity(0.2),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 6, 4, 5)),
              ),
            ),
            child: child!);
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // =====================
  // UI Builders
  // =====================
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 25.h,
        leading: PrimaryBackButton(),
        title: Text(AppLocalizations.of(context)!.editprofile,
            style: CustomTextStyles.appBarTitleText(context)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
      ),
      body: _isLoading
          ? ProfileSimmer()
          : ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 210.h,
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    height: 180.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: coverImage != null
                                          ? DecorationImage(
                                              image: FileImage(coverImage!),
                                              fit: BoxFit.fill,
                                            )
                                          : (userProvider.cover_photo == null ||
                                                  userProvider
                                                      .cover_photo!.isEmpty ||
                                                  userProvider.getCoverImage(
                                                          userProvider
                                                              .cover_photo) ==
                                                      null)
                                              ? DecorationImage(
                                                  image: AssetImage(Assets
                                                      .assetsImagesDefaultCover),
                                                  fit: BoxFit.fill)
                                              : DecorationImage(
                                                  image: MemoryImage(
                                                      userProvider.getCoverImage(
                                                          userProvider
                                                              .cover_photo)!),
                                                  fit: BoxFit.fill),
                                    ),
                                    child: Stack(
                                      children: [
                                        if (_isUploadingCover)
                                          Positioned.fill(
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          AppColors
                                                              .primaryColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              height: 25.h,
                                              width: 25.w,
                                              margin: EdgeInsets.only(
                                                  bottom: 7.h, right: 7.w),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.whiteColor,
                                              ),
                                              child: Icon(FeatherIcons.camera,
                                                  color: AppColors.primaryColor,
                                                  size: 13.spMax),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w),
                                  child: SizedBox(
                                    height: 130,
                                    width: 130,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 100.h,
                                          width: 100.w,
                                          margin: EdgeInsets.only(bottom: 4.h),
                                          padding: EdgeInsets.all(2).w,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color:
                                                      AppColors.primaryColor)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: profileImage != null
                                                  ? DecorationImage(
                                                      image: FileImage(
                                                          profileImage!),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : (userProvider
                                                                  .profile_picture ==
                                                              null ||
                                                          userProvider
                                                              .profile_picture!
                                                              .isEmpty ||
                                                          userProvider.getProfileImage(
                                                                  userProvider
                                                                      .profile_picture) ==
                                                              null)
                                                      ? DecorationImage(
                                                          image: AssetImage(Assets
                                                              .assetsImagesIcUser),
                                                          fit: BoxFit.cover)
                                                      : DecorationImage(
                                                          image: MemoryImage(
                                                            userProvider
                                                                .getProfileImage(
                                                                    userProvider
                                                                        .profile_picture)!,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 8.w,
                                          bottom: 12.h,
                                          child: GestureDetector(
                                            onTap: (){},
                                            child: Container(
                                              height: 22.h,
                                              width: 22.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primaryColor,
                                              ),
                                              child: Icon(FeatherIcons.camera,
                                                  color: Colors.white,
                                                  size: 13.spMax),
                                            ),
                                          ),
                                        ),
                                        if (_isUploadingProfile)
                                          Container(
                                            height: 100.h,
                                            width: 100.w,
                                            margin:
                                                EdgeInsets.only(bottom: 4.h),
                                            padding: EdgeInsets.all(2).w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                            ),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        AppColors.whiteColor),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        )),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: CustomCard(
                        widget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.usersettings,
                              style: CustomTextStyles.lblContentText(context),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              AppLocalizations.of(context)!.firstname,
                              style: CustomTextStyles.lblProfileContentText(
                                  context),
                            ),
                            SizedBox(height: 5.h),
                            _buildTextField(
                                _firstNameController,
                                TextInputType.text,
                                AppLocalizations.of(context)!.enterfirstname),
                            SizedBox(height: 12.h),
                            Text(
                              AppLocalizations.of(context)!.lastname,
                              style: CustomTextStyles.lblProfileContentText(
                                  context),
                            ),
                            SizedBox(height: 5.h),
                            _buildTextField(
                                _lastNameController,
                                TextInputType.text,
                                AppLocalizations.of(context)!.enterlastname),
                            SizedBox(height: 12.h),
                            Text(
                              AppLocalizations.of(context)!.username,
                              style: CustomTextStyles.lblProfileContentText(
                                  context),
                            ),
                            SizedBox(height: 5.h),
                            _buildTextField(
                                _usernameController,
                                TextInputType.text,
                                AppLocalizations.of(context)!.enterusername),
                            if (_usernameErrorText.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 5.h),
                                child: Text(_usernameErrorText,
                                    style: CustomTextStyles.msgErrorText),
                              ),
                            SizedBox(height: 12.h),
                            Text(
                              AppLocalizations.of(context)!.dateofbirth,
                              style: CustomTextStyles.lblProfileContentText(
                                  context),
                            ),
                            SizedBox(height: 5.h),
                            _buildDateOfBirthField(),
                            SizedBox(height: 12.h),
                            Text(
                              AppLocalizations.of(context)!.gender,
                              style: CustomTextStyles.lblProfileContentText(
                                  context),
                            ),
                            SizedBox(height: 5.h),
                            buildGenderField(),
                            SizedBox(height: 12.h),
                            Text(
                              AppLocalizations.of(context)!.bio,
                              style: CustomTextStyles.lblProfileContentText(
                                  context),
                            ),
                            SizedBox(height: 5.h),
                            _bioTextField(
                                _bioController,
                                TextInputType.multiline,
                                AppLocalizations.of(context)!.enterbio),
                            SizedBox(height: 12.h),
                            Text(
                              AppLocalizations.of(context)!.enteryouremail,
                              style: CustomTextStyles.lblProfileContentText(
                                  context),
                            ),
                            SizedBox(height: 5.h),
                            _buildTextField(
                                _emailController,
                                TextInputType.emailAddress,
                                AppLocalizations.of(context)!.enteryouremail),
                            SizedBox(height: 12.h),
                            Text(
                              AppLocalizations.of(context)!.phonenumber,
                              style: CustomTextStyles.lblProfileContentText(
                                  context),
                            ),
                            SizedBox(height: 5.h),
                            _buildPhoneNumber(
                                _phoneNumberController, _countryCode ?? '91'),
                            if (_showUpdateUsernameButton ||
                                _showUpdateProfileButton)
                              GestureDetector(
                                onTap: () {
                                  if (_showUpdateUsernameButton) {
                                    changeUsername();
                                  }
                                  if (_showUpdateProfileButton) {
                                    updateProfile();
                                  }
                                },
                                child: Container(
                                  height: 30.h,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 10.h),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(50.r)),
                                  child: Center(
                                    child: _isSaveProfile || _isSaveUsername
                                        ? Loader(color: Colors.white)
                                        : Text(
                                            AppLocalizations.of(context)!
                                                .savechanges,
                                            style: CustomTextStyles
                                                .btnPrimaryText),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: 15.h),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 12.w),
                    //   child: CustomCard(
                    //       widget: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         AppLocalizations.of(context)!.changepassword,
                    //         style: CustomTextStyles.lblContentText(context),
                    //       ),
                    //       SizedBox(height: 12.h),
                    //       Text(
                    //         AppLocalizations.of(context)!.currentpassword,
                    //         style:
                    //             CustomTextStyles.lblProfileContentText(context),
                    //       ),
                    //       SizedBox(height: 5.h),
                    //       _buildPasswordTextField(
                    //           _currentPasswordController,
                    //           TextInputType.visiblePassword,
                    //           AppLocalizations.of(context)!
                    //               .entercurrentpassword,
                    //           _isCurrentPasswordHidden, () {
                    //         setState(() {
                    //           _isCurrentPasswordHidden =
                    //               !_isCurrentPasswordHidden;
                    //         });
                    //       }),
                    //       if (currentPasswordErrorText != null)
                    //         Padding(
                    //           padding: EdgeInsets.only(top: 5.h),
                    //           child: Text(currentPasswordErrorText ?? '',
                    //               style: CustomTextStyles.msgErrorText),
                    //         ),
                    //       SizedBox(height: 5.h),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.end,
                    //         children: [
                    //           GestureDetector(
                    //             onTap: () {
                    //               navigationPush(
                    //                   context, ForgotPasswordScreen());
                    //             },
                    //             child: Text(
                    //               AppLocalizations.of(context)!
                    //                   .forgotyourpassword,
                    //               style: TextStyle(
                    //                 color:
                    //                     Theme.of(context).colorScheme.primary,
                    //                 fontWeight: FontWeight.w300,
                    //                 fontSize: 11.5.sp,
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Text(
                    //         AppLocalizations.of(context)!.newpassword,
                    //         style:
                    //             CustomTextStyles.lblProfileContentText(context),
                    //       ),
                    //       SizedBox(height: 5.h),
                    //       _buildPasswordTextField(
                    //           _newPasswordController,
                    //           TextInputType.visiblePassword,
                    //           AppLocalizations.of(context)!.enternewpassword,
                    //           _isNewPasswordHidden, () {
                    //         setState(() {
                    //           _isNewPasswordHidden = !_isNewPasswordHidden;
                    //         });
                    //       }),
                    //       if (newPasswordErrorText != null)
                    //         Padding(
                    //           padding: EdgeInsets.only(top: 5.h),
                    //           child: Text(newPasswordErrorText ?? '',
                    //               style: CustomTextStyles.msgErrorText),
                    //         ),
                    //       SizedBox(height: 12.h),
                    //       Text(
                    //         AppLocalizations.of(context)!.confirmpassword,
                    //         style:
                    //             CustomTextStyles.lblProfileContentText(context),
                    //       ),
                    //       SizedBox(height: 5.h),
                    //       _buildPasswordTextField(
                    //           _confirmPasswordController,
                    //           TextInputType.visiblePassword,
                    //           AppLocalizations.of(context)!
                    //               .enterconfirmpassword,
                    //           _isConfirmPasswordHidden, () {
                    //         setState(() {
                    //           _isConfirmPasswordHidden =
                    //               !_isConfirmPasswordHidden;
                    //         });
                    //       }),
                    //       if (confirmPasswordErrorText != null)
                    //         Padding(
                    //           padding: EdgeInsets.only(top: 5.h),
                    //           child: Text(confirmPasswordErrorText ?? '',
                    //               style: CustomTextStyles.msgErrorText),
                    //         ),
                    //       if (_showUpdatePasswordButton)
                    //         GestureDetector(
                    //           onTap: () {
                    //             if (_showUpdatePasswordButton) {
                    //               updatePassword();
                    //             }
                    //           },
                    //           child: Container(
                    //             height: 30.h,
                    //             width: double.infinity,
                    //             margin: EdgeInsets.only(top: 10.h),
                    //             decoration: BoxDecoration(
                    //                 color: AppColors.primaryColor,
                    //                 borderRadius: BorderRadius.circular(50.r)),
                    //             child: Center(
                    //               child: _isSavePassword
                    //                   ? Loader(color: Colors.white)
                    //                   : Text(
                    //                       AppLocalizations.of(context)!
                    //                           .savechanges,
                    //                       style:
                    //                           CustomTextStyles.btnPrimaryText),
                    //             ),
                    //           ),
                    //         )
                    //     ],
                    //   )),
                    // )
                  ],
                ),
                SizedBox(height: 30.h),
              ],
            ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    TextInputType inputType,
    String hintText,
  ) {
    return SizedBox(
      height: 35.h,
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        maxLines: null,
        style: CustomTextStyles.lblPrimaryText(context),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10.w),
          hintText: hintText,
          hintStyle: CustomTextStyles.lblPrimaryHintText(context),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(7)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.primaryColor.withOpacity(0.7)),
              borderRadius: BorderRadius.circular(7)),
        ),
      ),
    );
  }

  Widget _buildDateOfBirthField() {
    return Container(
      height: 35.h,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(7.r),
          border: Border.all(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
              width: 1)),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _dobController,
              readOnly: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.w, bottom: 5.h),
                hintText: AppStrings.lblDateOfBirth,
                hintStyle: CustomTextStyles.lblPrimaryHintText(context),
                border: InputBorder.none,
              ),
              style: CustomTextStyles.lblPrimaryText(context),
              onTap: _selectDate,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGenderField() {
    return Container(
      height: 35.h,
      width: double.infinity,
      padding: EdgeInsets.only(right: 12.w, left: 12.w, bottom: 5.h),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(7.r),
          border: Border.all(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
              width: 1)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            value: _selectedGender,
            dropdownColor: Theme.of(context).colorScheme.background,
            items: genderOptions.map((gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(
                  gender,
                  style: CustomTextStyles.lblPrimaryText(context),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedGender = newValue!;
                checkIfChangedProfile(_selectedGender, _initialGender);
              });
            },
            iconEnabledColor:
                Theme.of(context).colorScheme.onBackground.withOpacity(0.7)),
      ),
    );
  }

  Widget _bioTextField(
    TextEditingController controller,
    TextInputType inputType,
    String hintText,
  ) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: 5,
      style: CustomTextStyles.lblPrimaryText(context),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 10.w, top: 6.h),
        hintText: hintText,
        hintStyle: CustomTextStyles.lblPrimaryHintText(context),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(7)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.primaryColor.withOpacity(0.7)),
            borderRadius: BorderRadius.circular(7)),
      ),
    );
  }

  Widget _buildPhoneNumber(
    TextEditingController controller,
    String country_code,
  ) {
    // Get the country object from the dial code
    Country? initialCountry = getCountryByDialCode(_countryCode ?? '91');

    return Container(
      height: 35.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Country code section
          CustomCountryCode(
            initialCountry: initialCountry,
            onCountrySelected: (country) {
              setState(() {
                _countryCode = country.dialCode.replaceAll('+', '');
              });
            },
          ),
          // Vertical divider
          Container(
            height: 20.h,
            width: 1,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
          ),
          // Phone number input
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: CustomTextStyles.lblPrimaryText(context),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 5.w, bottom: 4.h),
                hintText: AppLocalizations.of(context)!.enteryourphonenumber,
                hintStyle: CustomTextStyles.lblPrimaryHintText(context),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTextField(
    TextEditingController controller,
    TextInputType inputType,
    String hintText,
    bool isHidden,
    VoidCallback? onTap,
  ) {
    return SizedBox(
      height: 35.h,
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        style: CustomTextStyles.lblPrimaryText(context),
        obscureText: isHidden,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10.w),
          hintText: hintText,
          hintStyle: CustomTextStyles.lblPrimaryHintText(context),
          border: InputBorder.none,
          suffixIcon: IconButton(
              onPressed: onTap,
              icon: Icon(isHidden ? FeatherIcons.eyeOff : FeatherIcons.eye,
                  size: 20,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.13))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(7)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.primaryColor.withOpacity(0.7)),
              borderRadius: BorderRadius.circular(7)),
        ),
      ),
    );
  }
}
