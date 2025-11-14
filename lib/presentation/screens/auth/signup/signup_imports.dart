import 'package:dio/dio.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'dart:io';

import '../../../../api/app_api.dart';
import '../../../../api/model/country/country_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../data/token/shared_preferences.dart';
import '../../../../mixins/utility_mixins.dart';
import '../../../common widgets/country code/custom_country_code.dart';
import '../../../common widgets/text field/primary_textfield.dart';
import '../../../common widgets/custom_card.dart';
import '../../../common widgets/custom_text_styles.dart';
import '../../../common widgets/button/auth_button.dart';
import '../login/login_import.dart';

part 'signup_screen.dart';