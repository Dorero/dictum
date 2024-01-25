import 'package:dictum/api/local_storage.dart';
import 'package:flutter/material.dart';

class LocaleViewModel extends ChangeNotifier {
  Locale _locale = const Locale("ru");

  Locale get locale => _locale;

  void set(Locale locale) {
    _locale = locale;
    LocaleStorage.prefs.setString("language", _locale.languageCode);
    notifyListeners();
  }
}