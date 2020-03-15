import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider {

  static final _instance = UserDataProvider._internal();

  factory UserDataProvider(){
    return _instance;
  }

  UserDataProvider._internal();

  static const _KEY_IS_LOGGED_IN = "is_logged_in";
  static const _KEY_HAS_SET_SLOTS = "slots_set";

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_KEY_IS_LOGGED_IN) ?? false;
  }

  Future<bool> setLoggedIn(bool loggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_KEY_IS_LOGGED_IN, loggedIn) ?? true;
  }

  Future<bool> hasSlotsSet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_KEY_HAS_SET_SLOTS) ?? false;
  }

  Future<bool> setSlots(bool isSet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_KEY_HAS_SET_SLOTS, isSet) ?? true;
  }

  Future<bool> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}