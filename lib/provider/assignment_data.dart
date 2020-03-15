import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignmentDataProvider extends ChangeNotifier {

  List<int> weeklySlots = [1,1,1,1,1,1,1];

  void setWeeklySlot(int weekDay, int minutes){
    weeklySlots[weekDay] = minutes;
    notifyListeners();
  }

  Future<List<int>> loadWeeklySlots() async {
    var prefs = await SharedPreferences.getInstance();
    var slotsJson = prefs.getString("weekly_slots") ?? '''[1,1,1,1,1,1,1]''';
    weeklySlots = (jsonDecode(slotsJson) as List).map((e) => e as int).toList();
    return weeklySlots;
  }

  Future<bool> saveWeeklySlots(List<int> slots) async {
    var prefs = await SharedPreferences.getInstance();
    debugPrint(jsonEncode(slots));
    prefs.setString("weekly_slots", jsonEncode(slots));
  }


}