import 'dart:convert';

import 'package:TimeTek/adviser/adviser.dart';
import 'package:TimeTek/model/assignment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum STATUS{
  NONE, LOADING, SUCCESS, ERROR
}

class AssignmentDataProvider extends ChangeNotifier {

  List<int> weeklySlots = [0,0,0,0,0,0,0];
  List<Assignment> assignments;
  STATUS assignmentStatus;

  STATUS adviserStatus;
  Map<String, DailyAllotment> advise = {};

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
    assignmentStatus = STATUS.LOADING;
    notifyListeners();

    var prefs = await SharedPreferences.getInstance();
    var json = prefs.getString("assignments") ?? "[]";
    assignments = (jsonDecode(json) as List).map((e) => Assignment.fromJson(e)).toList();

    assignmentStatus = STATUS.SUCCESS;
    notifyListeners();
  }

  Future saveAssignments() async {
    var prefs = await SharedPreferences.getInstance();
    debugPrint(jsonEncode(assignments));
    prefs.setString("assignments", jsonEncode(assignments));
  }

  Future addMinutes(String assignmentId, int minutes) async {
    Assignment assignment = assignments.firstWhere((it) => it.id == assignmentId);
    if(assignment != null){
      assignment.spentMinutes = (assignment.spentMinutes ?? 0) + minutes;
      await saveAssignments();
      notifyListeners();
    }
  }

  Future finishAssignment(String assignmentId) async {
    Assignment assignment = assignments.firstWhere((it) => it.id == assignmentId);
    if(assignment != null){
      assignment.finished = true;
      await saveAssignments();
      notifyListeners();
    }
  }

  Future addAssignment(Assignment assignment) async {

    if(assignments == null || assignments.isEmpty){
      await loadAssignments();
    }

    assignments.add(assignment);

    await saveAssignments();

    notifyListeners();

    makeAdvise();

  }

  Future makeAdvise() async {

    adviserStatus = STATUS.LOADING;
    notifyListeners();

    await loadAssignments();
    List<Assignment> assignmentsAhead = List.from(assignments);

    assignmentsAhead.retainWhere((assmt) => assmt.endDate.isAfter(DateTime.now()) && !assmt.isFinished);

    debugPrint("Have ${assignmentsAhead.length} assignments to process.");

    if(assignmentsAhead.isEmpty){
      advise = {};
      adviserStatus = STATUS.NONE;
      notifyListeners();
      return;
    }

    Adviser adviser = Adviser(assignmentsAhead, await loadWeeklySlots());

    advise = adviser.allotment;

    adviserStatus = STATUS.SUCCESS;
    notifyListeners();
  }

}