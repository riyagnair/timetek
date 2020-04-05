import 'dart:convert';

import 'package:TimeTek/model/assignment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignmentDataProvider extends ChangeNotifier {

  List<int> weeklySlots = [0,0,0,0,0,0,0];
  List<Assignment> assignments;

  void setWeeklySlot(int weekDay, int minutes){
    weeklySlots[weekDay] = minutes;
    notifyListeners();
  }

  Future<int> getTodaySlot() async {
    await loadWeeklySlots();
    return weeklySlots[DateTime.now().weekday%7] ?? 120;
  }

  Future<List<int>> loadWeeklySlots() async {
    var prefs = await SharedPreferences.getInstance();
    var slotsJson = prefs.getString("weekly_slots") ?? '''[0,0,0,0,0,0,0]''';
    weeklySlots = (jsonDecode(slotsJson) as List).map((e) => e as int).toList();
    return weeklySlots;
  }

  Future<bool> saveWeeklySlots(List<int> slots) async {
    var prefs = await SharedPreferences.getInstance();
    debugPrint(jsonEncode(slots));
    prefs.setString("weekly_slots", jsonEncode(slots));
  }

  Future loadAssignments() async {
    var prefs = await SharedPreferences.getInstance();
    var json = prefs.getString("assignments") ?? "[]";
    assignments = (jsonDecode(json) as List).map((e) => Assignment.fromJson(e)).toList();
  }

  Future saveAssignments() async {
    var prefs = await SharedPreferences.getInstance();
    debugPrint(jsonEncode(assignments));
    prefs.setString("assignments", jsonEncode(assignments));
  }

  Future addAssignment(Assignment assignment) async {

    if(assignments == null || assignments.isEmpty){
      await loadAssignments();
    }

    assignments.add(assignment);

    await saveAssignments();

    notifyListeners();

  }


}