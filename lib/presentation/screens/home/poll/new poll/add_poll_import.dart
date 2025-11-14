import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polzet_mobile_app/api/api_service.dart';
import 'package:polzet_mobile_app/provider/user_provider.dart';

import '../../../../../api/app_api.dart';
import '../../../../../data/token/shared_preferences.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../../../mixins/utility_mixins.dart';
import '../../../../common widgets/button/back_button.dart';
import '../../../../common widgets/button/primary_button.dart';
import '../../../../common widgets/custom_text_styles.dart';
import '../../../../common widgets/show_toast.dart';
import '../../../../common widgets/text field/secondry_textfield.dart';
import '../../../profile/things/user_things_questions_list.dart';
import 'primary_image_picker.dart';

part 'add_poll_answer.dart';
part 'add_poll_image.dart';