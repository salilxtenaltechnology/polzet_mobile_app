import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:polzet_mobile_app/src/login_screen/login_screen.dart';
import 'package:polzet_mobile_app/src/login_screen/email_varification_screen.dart';
import 'package:polzet_mobile_app/src/home_screen/home_screen.dart';
import 'dart:io'; // Add this for HTTP overrides

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Add SSL bypass for development (remove in production)
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());
}

// SSL Handshake Exception Fix (Temporary for development)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Polzet',
          initialRoute: '/',
          routes: {
            '/': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/email_varification') {
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (context) => EmailVerificationScreen(
                  email: args?['email'] ?? '',
                ),
              );
            }
            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
                builder: (context) => Scaffold(
              body: Center(child: Text('404: Page not found')),
            ));
          },
        );
      },
    );
  }
}