import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider {

  static final _instance = UserDataProvider._internal();

  factory UserDataProvider(){
    return _instance;
  }

  UserDataProvider._internal();

  static const _KEY_IS_LOGGED_IN = "is_logged_in";
  static const _KEY_HAS_SET_SLOTS = "slots_set";
  static const _KEY_AVATAR = "avatar";
  static const _KEY_NAME = "name";

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_KEY_IS_LOGGED_IN) ?? false;
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_KEY_NAME) ?? false;
  }

  Future<String> getAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_KEY_AVATAR) ?? false;
  }

  Future<bool> setLoggedIn(bool loggedIn, {String avatar, String name,}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_KEY_NAME, name);
    await prefs.setString(_KEY_AVATAR, avatar);
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