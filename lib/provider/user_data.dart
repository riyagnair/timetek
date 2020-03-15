import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider extends ChangeNotifier {

  static const _KEY_IS_LOGGED_IN = "is_logged_in";

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_KEY_IS_LOGGED_IN);
  }

  void setLoggedIn(bool loggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_KEY_IS_LOGGED_IN, loggedIn);
  }

}