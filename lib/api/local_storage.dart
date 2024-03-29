import 'package:shared_preferences/shared_preferences.dart';

abstract class LocaleStorage {
  static late final SharedPreferences prefs;

  static Future<SharedPreferences> init() async =>
      prefs = await SharedPreferences.getInstance();
}