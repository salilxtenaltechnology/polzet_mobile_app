import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_icons.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../mixins/utility_mixins.dart';
import '../../common widgets/bottom navigation bar/bottom_navigation_bar.dart';
import '../../common widgets/button/custom_floating_button.dart';
import '../../common widgets/custom_text_styles.dart';
import '../../common widgets/poll/new_poll_bottomsheet.dart';
import '../profile/user_profile_import.dart';
import '../settings/settings_import.dart';
import 'dashboard/dashboard_import.dart';
import 'insights/insights_screen.dart';
import 'message/message_list.dart';
import 'notifications/notification.dart';
import 'poll/new poll/poll_pop.dart';
import 'poll/poll group/poll_group_list.dart';
import '../../../provider/user_provider.dart';
import 'search/user_search_import.dart';

part 'home_screen.dart';