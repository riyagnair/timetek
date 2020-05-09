import 'package:TimeTek/adviser/adviser.dart';
import 'package:TimeTek/model/assignment.dart';
import 'package:TimeTek/provider/assignment_data.dart';
import 'package:TimeTek/util/helpers_and_utils.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

abstract class _ListItem {
  Widget build(BuildContext context, {Function onTap});
}

class _HeaderItem implements _ListItem {

  String title;
  int availableMins;
  int allottedMins;

  bool get isEmpty => allottedMins == 0;
  bool get overbooked => availableMins < allottedMins;
  int get extraMinutes => allottedMins - availableMins;

  _HeaderItem(this.title, this.availableMins, this.allottedMins);

  @override
  Widget build(BuildContext context, {Function onTap}) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      color: overbooked
        ? Colors.red
        : this.isEmpty ? Colors.green.withOpacity(0.5) : Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: this.isEmpty ? Colors.white.withOpacity(0.5) : Colors.white,
            ),
          ),

          Visibility(
            visible: overbooked,
            child: Text(
              "overbooked by ${printDuration(Duration(minutes: extraMinutes))}",
              style: GoogleFonts.raleway(
                fontSize: 14,
                color: this.isEmpty ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _NoneItem implements _ListItem {

  String title;

  _NoneItem({this.title});

  @override
  Widget build(BuildContext context, {Function onTap}) {
    return ListTile(
      title: Text(
        this.title ?? "No items for this day.",
        style: GoogleFonts.raleway(
          color: Colors.white.withOpacity(0.5),
        )
      )
    );
  }
}

class _AllotmentItem implements _ListItem {
  Assignment _assignment;
  int minutes;

  _AllotmentItem(this._assignment, this.minutes);

  @override
  Widget build(BuildContext context, {Function onTap}) {
    return ListTile(
      title: Text(
        _assignment.title,
        style: GoogleFonts.raleway(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )
      ),
      trailing: Text(
        "${printDuration(Duration(minutes: minutes))}",
        style: GoogleFonts.raleway(
          color: Colors.white.withOpacity(0.5),
        )
      ),
    );
  }
}

class AdviserScreen extends StatefulWidget {

  @override
  _AdviserScreenState createState() => _AdviserScreenState();
}

class _AdviserScreenState extends State<AdviserScreen> {

  static DateFormat _dateFormat = DateFormat("MMM dd");

  List<_ListItem> processItems(Map<String, DailyAllotment> allotments) {

    List<_ListItem> finalList = [];

    allotments.forEach((key, value) {

      finalList.add(
        _HeaderItem(
          "${_dateFormat.format(value.dateTime)}",
          value.availableMinutes,
          value.bookedMinutes,
        ),
      );

      if(value.slots.isEmpty){
        finalList.add(_NoneItem());
      } else {
        value.slots.forEach((assmt, minutes) => finalList.add(_AllotmentItem(assmt, minutes)));
      }

    });

    return finalList;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      Provider.of<AssignmentDataProvider>(context, listen: false).makeAdvise();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentDataProvider>(builder: (_, provider, __) {

      switch(provider.adviserStatus){

        case STATUS.NONE:
          return Center(
            child: Text("Hoo! No assignments to do."),
          );

        case STATUS.LOADING:
          return Center(
            child: CircularProgressIndicator(),
          );

        case STATUS.SUCCESS:

          if(provider.assignments != null && provider.assignments.isNotEmpty){

            List<_ListItem> list = processItems(provider.advise);

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                _ListItem _listItem = list[index];
                return _listItem.build(
                  context,
                  onTap: _listItem is _AllotmentItem
                    ? () => _updateAssignment(context, provider, _listItem._assignment)
                    : null,
                );
              }
            );
          }

          return Center(
            child: Text("Hoo! No assignments to do."),
          );

        case STATUS.ERROR:
          return Center(
            child: Text("Error loading assignments"),
          );
          break;

        default: Center(
          child: Text("Hoo! No assignments to do."),
        );
      }

      return Center(
        child: Text("You don't have assignments yet."),
      );

    });
  }

  _updateAssignment(BuildContext context, AssignmentDataProvider provider, Assignment assignment) async {

    int minutes = await showModalBottomSheet(
      context: context,
      builder: (_){
        return FutureBuilder(
          future: provider.getTodaySlot(),
          builder: (ctx, snapshot){

            debugPrint("$snapshot");

            if(snapshot.hasData){
              return UpdateHoursWidget(assignment, snapshot.data);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );

    if(minutes != null && minutes > 0){
      await provider.addMinutes(assignment.id, minutes);
    }

    if(minutes != null && minutes == -1){ // For now, -1 for "Mark as complete"
      await provider.finishAssignment(assignment.id);
    }

  }
}

class UpdateHoursWidget extends StatefulWidget {

  final Assignment assignment;
  final int maxMinutes;

  const UpdateHoursWidget(
    this.assignment,
    this.maxMinutes,
    {
      Key key,
    }) : super(key: key);

  @override
  _UpdateHoursWidgetState createState() => _UpdateHoursWidgetState();
}

class _UpdateHoursWidgetState extends State<UpdateHoursWidget> {

  // Selected minutes
  int minutes = 0;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12)
        ),
        border: Border.all(color: Theme.of(context).primaryColor)
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          // Title and "Edit"
          Row(
            children: <Widget>[
              Text(
                widget.assignment.title,
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.edit),
              )
            ],
          ),

          Divider(
            color: Colors.white.withOpacity(0.9),
          ),

          // Start / Due Date Labels
          Row(
            children: <Widget>[
              Text("Start Date", style: GoogleFonts.raleway(color: Colors.white.withOpacity(0.6)),),
              Spacer(),
              Text("Due Date", style: GoogleFonts.raleway(color: Colors.white.withOpacity(0.6)),),
            ],
          ),

          // Start / Due Date Values
          Row(
            children: <Widget>[
              Text(formatDate(widget.assignment.startDate), style: GoogleFonts.raleway(fontSize: 16),),
              Spacer(),
              Text(formatDate(widget.assignment.endDate), style: GoogleFonts.raleway(fontSize: 16),),
            ],
          ),

          SizedBox(
            height: 24,
          ),

          // Text: spent hours
          Visibility(
            visible: widget.assignment.percentageDone != 100, // No need if this is already done.
            child: Text(
              minutes > 0 ?"You spent ${printDuration(Duration(minutes: minutes))}" : "Use the slider to enter the hours",
              textAlign: TextAlign.left,
              style: GoogleFonts.raleway(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16
              ),
            ),
          ),

          // Time slider
          Visibility(
            visible: widget.assignment.percentageDone != 100,
            child: Slider(
              min: 0,
              max: widget.maxMinutes.toDouble(),
              divisions: widget.maxMinutes ~/ 15,
              value: minutes.toDouble(),
              onChanged: (value) => setState((){ minutes = value.toInt(); }),
              activeColor: Colors.deepPurpleAccent,
              inactiveColor: Colors.white,
            ),
          ),

          // Label: Maximum hours
          Visibility(
            visible: widget.assignment.percentageDone != 100,
            child: Text(
              "Based on your weekly availability slots, you can spend maximum ${printDuration(Duration(minutes: widget.maxMinutes))} today.",
              textAlign: TextAlign.left,
              style: GoogleFonts.raleway(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),

          Spacer(),

          Visibility(
            visible: widget.assignment.percentageDone == 100,
            child: FlatButton(
              onPressed: () => Navigator.pop(context, -1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90)
              ),
              padding: EdgeInsets.all(0),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ Color(0xFFB4A5FE), Color(0xFF8563EA) ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  constraints: BoxConstraints(minHeight: 35),
                  alignment: Alignment.center,
                  child: Text(
                    "Mark this assignment as completed",
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ),

          Visibility(
            visible: minutes > 0,
            child: FlatButton(
              onPressed: minutes > 0 ? () => Navigator.pop(context, minutes) : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90)
              ),
              padding: EdgeInsets.all(0),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ Color(0xFFB4A5FE), Color(0xFF8563EA) ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 180, minHeight: 35),
                  alignment: Alignment.center,
                  child: Text(
                    "Add Hours",
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ),

          // More space.

        ],
      ),
    );
  }
}
