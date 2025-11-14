// ignore_for_file: undefined_hidden_name

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glass/glass.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';


import '../../../api/api_config.dart';
import '../../../api/api_service.dart';
import '../../../api/app_api.dart';
import '../../../api/model/country/country_model.dart';
import '../../../api/model/posts/post_images_model.dart';
import '../../../api/model/posts/post_polls_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/token/shared_preferences.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../mixins/utility_mixins.dart';
import '../../../provider/user_provider.dart';
import '../../common widgets/button/back_button.dart';
import '../../common widgets/country code/custom_country_code.dart';
import '../../common widgets/custom_card.dart';
import '../../common widgets/custom_text_styles.dart';
import '../../common widgets/loader.dart';
import '../../common widgets/poll/card/user_things_card.dart';
import '../../common widgets/show_toast.dart';
import '../../simmer/profile_simmer.dart';
import '../../simmer/vibes_simmer.dart';
import '../home/poll/new poll/add_poll_import.dart';
import 'vibes/user_vibes.dart';
import 'posts/user_image_posts.dart';
import 'public/public_profile.dart' hide PostCard;
import 'things/user_things_questions_list.dart';

part 'user_profile.dart';
part 'edit/edit_profile.dart';