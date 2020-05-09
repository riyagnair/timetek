import 'package:TimeTek/model/assignment.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DailyAllotment {
  static const int SLOT_TIME = 30; // 30 minutes of allotment

  DateTime dateTime; // Date of this allotment.
  int maxMinutes;

  // Check if the allocation is over for a day.
  bool get isOverBooked {
    int booked = slots.values.fold(0, (previousValue, element) => previousValue + element);
    return booked > maxMinutes;
  }

  Map<Assignment, int> slots = {}; // Allotted assignment and the time allotted for them.

  DailyAllotment(this.dateTime, this.maxMinutes);

  void allot(Assignment assignment, {int minutes = SLOT_TIME}) {

    if(slots.containsKey(assignment)){
      slots[assignment] = slots[assignment.id] + minutes;
    } else {
      slots[assignment] = minutes;
    }

  }
}

class Adviser {
  List<Assignment> assignments;
  List<int> slots;

  Map<String, DailyAllotment> _dailyAllotment = {};

  Adviser(this.assignments, this.slots);

  void allotAssignments(){

    // 1. find last assignment date, and take 1 more day.
    DateTime last = _lastAssignmentDate();


    // 2. Create a map of allocation, from today to the last available date.
    int days = last.difference(DateTime.now()).inDays;

    DateTime dayIterator = DateTime.now();
    for(int i = 0; i<days; i++){
      _dailyAllotment[_indexOf(dayIterator)] = DailyAllotment(dayIterator, slots[dayIterator.weekday%7]);
      dayIterator = dayIterator.add(Duration(days: 1));
    }

    _dailyAllotment.forEach((key, value) {
      debugPrint("Having a day: $key, $value");
    });



  }

  Map<String, DailyAllotment> get allotment {
    allotAssignments();
    return _dailyAllotment;
  }

  DateTime _lastAssignmentDate(){
    if(assignments.isEmpty){
      return DateTime.now();
    }

    return assignments.fold(
      DateTime.now(),
      (prevDate, assmt) => assmt.endDate.isAfter(prevDate) ? assmt.endDate : prevDate
    );
  }

  static DateFormat _indexFormat = DateFormat("yyyy-MM-dd");
  String _indexOf(DateTime dateTime) => _indexFormat.format(dateTime);

}
