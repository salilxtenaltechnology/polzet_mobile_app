// ignore_for_file: unused_field, deprecated_member_use, unused_element, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_strings.dart';
import 'core/themes/app_themes.dart';
import 'core/themes/theme_provider.dart';
import 'data/token/shared_preferences.dart';
import 'l10n/generated/app_localizations.dart';
import 'provider/user_provider.dart';
import 'screens/splash/splash_screen.dart';

// Created by -- Dev.Pratik Patadiya on 27/03/2025
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
    // Additional security check when app initializes
  }

  Future<bool> isLoggedIn() async {
    final accessToken = await SharedPrefService.getAccessToken();
    return accessToken != null;
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode);
      });
    }
  }

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Future<Widget> _getInitialScreen() async {
    // Perform security check before determining initial screen

    final bool isUserLoggedIn = await isLoggedIn();

    if (!isUserLoggedIn) {
      return SplashScreen(isLogged: false);
    }

    // No security enabled, proceed to main app
    return SplashScreen(isLogged: true);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        locale: _locale,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ar'), // Arabic
          Locale('en'), // English
          Locale('de'), // German
          Locale('hi'), // Hindi
          Locale('id'), // Indonesian
          Locale('es'), // Spanish
          Locale('vi'), // Vietnamese
        ],
        theme: AppThemes.lightMode,
        darkTheme: AppThemes.darkMode,
        themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        title: AppStrings.appName,
        home: FutureBuilder<Widget>(
          future: _getInitialScreen(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body: const Center(child: CircularProgressIndicator()),
              );
            } else if (asyncSnapshot.hasError) {
              return SplashScreen(isLogged: false);
            } else {
              return asyncSnapshot.data ?? SplashScreen(isLogged: false);
            }
          },
        ),
      ),
    );
  }
}
