import 'package:TimeTek/model/assignment.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DailyAllotment {
  static const int SLOT_TIME = 15; // 15 minutes of allotment

  DateTime dateTime; // Date of this allotment.

  int availableMinutes;
  int bookedMinutes = 0;

  // Check if the allocation is over for a day.
  bool get isOverBooked {
    int booked = slots.values.fold(0, (previousValue, element) => previousValue + element);
    return booked > availableMinutes;
  }

  Map<Assignment, int> slots = {}; // Allotted assignment and the time allotted for them.

  DailyAllotment(this.dateTime, this.availableMinutes);

  void allot(Assignment assignment, {int minutes = SLOT_TIME}) {

    if(slots.containsKey(assignment)){
      slots[assignment] = slots[assignment] + minutes;
    } else {
      slots[assignment] = minutes;
    }

    bookedMinutes += minutes;

  }
}

class Adviser {

  static const int SLOT_TIME = 15; // 30 minutes of allotment

  List<Assignment> assignments;
  List<int> slots;

  Map<String, DailyAllotment> _dailyAllotment = {};

  Adviser(this.assignments, this.slots);

  void allotAssignments(){

    // 1. find last assignment date, and take 1 more day.
    DateTime last = _lastAssignmentDate();

    debugPrint("lastAssignment: ${_indexFormat.format(last)}");


    // 2. Create a map of allocation, from today to the last available date.
    int days = last.difference(DateTime.now()).inDays + 1;


    DateTime dayIterator = DateTime.now();
    for(int i = 0; i<days; i++){
      _dailyAllotment[_indexOf(dayIterator)] = DailyAllotment(dayIterator, slots[dayIterator.weekday%7]);
      dayIterator = dayIterator.add(Duration(days: 1));
    }

    _dailyAllotment.forEach((key, value) {
      debugPrint("Having a day: $key, $value");
    });

    // 3. Sort assignments, upcoming submissions first.
    assignments.sort((Assignment a1, Assignment a2) => a1.endDate.compareTo(a2.endDate));

    // 4. For each assignment, allocate 30minutes from the end-date to today / start date.
    assignments.forEach((assignment) {

      DateTime startDate = assignment.startDate.isBefore(DateTime.now()) ? DateTime.now() : assignment.startDate;
      DateTime endDate = assignment.endDate.subtract(Duration(days: 1));
      DateTime dateTimeIterator = endDate;

      int remainingMinutes = assignment.remainingMinutes;

      while(remainingMinutes > 0){

        String key = _indexFormat.format(dateTimeIterator);

        debugPrint("Alloting ${assignment.title} on ${key}");
        _dailyAllotment[key].allot(assignment, minutes: SLOT_TIME);

        remainingMinutes -= SLOT_TIME;

        dateTimeIterator = dateTimeIterator.subtract(Duration(days: 1));

        // Restart from the end-date if this comes before the start-date.
        if(dateTimeIterator.isBefore(startDate)){
          dateTimeIterator = endDate;
        }

      }

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
