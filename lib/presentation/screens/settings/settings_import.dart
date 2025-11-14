

import 'dart:async';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:polzet_mobile_app/l10n/generated/app_localizations.dart' show AppLocalizations;
import 'package:provider/provider.dart';

import '../../../api/app_api.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../data/token/shared_preferences.dart';
import '../../../mixins/utility_mixins.dart';
import '../../common widgets/button/back_button.dart';
import '../../common widgets/custom_text_styles.dart';
import '../../common widgets/diolog/custom_diolog.dart';
import '../../common widgets/show_toast.dart';
import '../auth/login/login_import.dart';
import '../home/poll/poll_designs.dart';
import '../profile/user_profile_import.dart';
import 'help and support/help_support.dart';
import 'language/language_import.dart';
import 'notifications/notifications.dart';
import 'privacy/privacy_policy.dart';
import 'security/security.dart';
import 'terms and policy/terms_and_conditions.dart';

part 'settings.dart';