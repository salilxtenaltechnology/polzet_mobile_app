import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/api_service.dart';
import '../../../../api/model/search/search_user_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../mixins/utility_mixins.dart';
import '../../../../provider/user_provider.dart';
import '../../../common widgets/button/back_button.dart';
import '../../../common widgets/button/primary_button.dart';
import '../../../common widgets/custom_card.dart';
import '../../../common widgets/custom_text_styles.dart';
import '../../../common widgets/show_toast.dart';
import '../../../common widgets/tabbar/indicator_animation.dart';
import '../../../simmer/search_user_simmer.dart';
import '../../group/add_member.dart';
import '../../profile/public/public_profile.dart';

part 'user_search.dart';
