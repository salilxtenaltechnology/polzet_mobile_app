// ignore_for_file: unused_field, deprecated_member_use, unused_element
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_strings.dart';
import 'core/themes/app_themes.dart';
import 'core/themes/theme_provider.dart';
import 'data/biometric/biometric_service.dart';
import 'data/internet/connection_provider.dart';
import 'data/pin/pin_service.dart';
import 'data/token/shared_preferences.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/screens/auth/login/pin/verify_pin_screen.dart';
import 'presentation/screens/biometric/biometric_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'provider/public_profile_provider.dart';
import 'provider/user_provider.dart';

// Created by -- Dev.Pratik Patadiya on 27/03/2025
void main()  {

  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PublicProfileProvider()),
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

  // Check security settings in order of priority
  final bool isPinSecurityEnabled = await PinService.isPinSecurityEnabled();
  final bool isBiometricEnabled = await BiometricService.isAnyBiometricMethodEnabled();
  final bool isBiometricAvailable = await BiometricService.isBiometricAvailable();
       
  // If PIN security is enabled, show PIN verification screen first
  if (isUserLoggedIn && isPinSecurityEnabled) {
    return PinGateScreen();
  }
       
  // If no PIN but biometric is enabled, show splash with biometric requirement
  if (isUserLoggedIn && isBiometricEnabled && isBiometricAvailable) {
    return SplashScreen(isLogged: true, requiresBiometric: true);
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
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          title: AppStrings.appName,
          home: FutureBuilder<Widget>(
              future: _getInitialScreen(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    body: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (asyncSnapshot.hasError) {
                  return SplashScreen(isLogged: false);
                } else {
                  return asyncSnapshot.data ?? SplashScreen(isLogged: false);
                }
              }),
        ));
  }
}

// PIN Gate Screen - Blocks access until PIN is verified
class PinGateScreen extends StatefulWidget {
  @override
  _PinGateScreenState createState() => _PinGateScreenState();
}

class _PinGateScreenState extends State<PinGateScreen> {
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    // Optionally show PIN screen immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPinVerification();
    });
  }

  void _showPinVerification() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyPinScreen(
          title: 'Enter PIN to continue',
          subtitle: 'Please enter your PIN to access the app',
          onPinVerified: (isVerified) {
            if (isVerified) {
              _proceedToMainApp();
            } else {
              // PIN verification failed, show error or try again
              _showPinVerificationError();
            }
          },
        ),
        settings: RouteSettings(name: '/verify_pin'),
      ),
    );

    // Handle the result if needed
    if (result == true) {
      _proceedToMainApp();
    } else if (result == false || result == null) {
      // User cancelled or verification failed
      _showPinVerificationError();
    }
  }

  void _proceedToMainApp() {
    // Check if biometric is also enabled after PIN verification
    _checkForAdditionalSecurity();
  }

  Future<void> _checkForAdditionalSecurity() async {
    final bool isBiometricEnabled =
        await BiometricService.isAnyBiometricMethodEnabled();
    final bool isBiometricAvailable =
        await BiometricService.isBiometricAvailable();

    if (isBiometricEnabled && isBiometricAvailable) {
      // Show biometric authentication after PIN
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BiometricGateScreen(),
        ),
      );
    } else {
      // Proceed directly to main app
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(isLogged: true),
        ),
      );
    }
  }

  void _showPinVerificationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PIN verification failed. Please try again.'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Retry',
          onPressed: _showPinVerification,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 20),
            Text(
              'App Locked',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please verify your PIN to continue',
              style: TextStyle(
                fontSize: 16,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 30),
            if (_isVerifying)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _showPinVerification,
                child: Text('Enter PIN'),
              ),
          ],
        ),
      ),
    );
  }
}