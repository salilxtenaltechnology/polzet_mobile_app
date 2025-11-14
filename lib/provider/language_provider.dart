// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LanguageProvider extends ChangeNotifier{
//   static const String _languageCodeKey = 'language';

//   static Future<void> setLocale(Locale locale) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_languageCodeKey, locale.languageCode);
//   }

//    Future<Locale?> getLocale() async {
//     final prefs = await SharedPreferences.getInstance();
//     final languageCode = prefs.getString(_languageCodeKey);
//     if (languageCode != null) {
//       return Locale(languageCode);
//     }
//     return null;
//   }
// }