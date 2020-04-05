import 'dart:collection';

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

  _HeaderItem(this.title);

  @override
  Widget build(BuildContext context, {Function onTap}) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      color: Theme.of(context).primaryColor,
      child: Text(
        title,
        style: GoogleFonts.raleway(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _AssignmentItem implements _ListItem {
  Assignment _assignment;

  _AssignmentItem(this._assignment);

  @override
  Widget build(BuildContext context, {Function onTap}) {
    return ListTile(
      onTap: onTap,
      title: Text(_assignment.title, style: GoogleFonts.raleway(color: Colors.white)),
      subtitle: Text(_assignment.statusStr,
          style: GoogleFonts.raleway(color: Colors.grey)),
      leading: Icon(Icons.today),
    );
  }
}

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<_ListItem> processItems(List<Assignment> items) {
    List<Assignment> l1 = items.where((it) => (it.finished == null || it.finished == false)).toList();

    l1.sort((a, b) => b.endDate.compareTo(a.endDate));

    Set<String> set = HashSet();
    l1.forEach((it) => set.add(DateFormat("MMM dd").format(it.endDate)));

    debugPrint("Set is $set");

    List<_ListItem> finalList = [];

    set.forEach((it) {
      finalList.add(_HeaderItem("Due on $it"));
      l1.where((a) => DateFormat("MMM dd").format(a.endDate) == it).forEach((a) => finalList.add(_AssignmentItem(a)));
    });

    debugPrint("Final List $finalList");

    return finalList;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      Provider.of<AssignmentDataProvider>(context, listen: false).loadAssignments();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentDataProvider>(builder: (_, provider, __) {

      switch(provider.assignmentStatus){

        case STATUS.NONE:
          return Center(
            child: Text("You don't have assignments."),
          );

        case STATUS.LOADING:
          return Center(
            child: CircularProgressIndicator(),
          );

        case STATUS.SUCCESS:

          if(provider.assignments != null && provider.assignments.isNotEmpty){
            List<_ListItem> list = processItems(provider.assignments);

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                _ListItem _listItem = list[index];
                return _listItem.build(
                  context,
                  onTap: _listItem is _AssignmentItem
                    ? () => _updateAssignment(context, provider, _listItem._assignment)
                    : null,
                );
              }
            );
          }

          return Center(
            child: Text("You don't have assignments."),
          );

        case STATUS.ERROR:
          return Center(
            child: Text("Error loading assignments"),
          );
          break;

        default: Center(
          child: Text("You don't have assignments."),
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
          Text(
            minutes > 0 ?"You spent ${printDuration(Duration(minutes: minutes))}" : "Use the slider to enter the hours",
            textAlign: TextAlign.left,
            style: GoogleFonts.raleway(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16
            ),
          ),

          // Time slider
          Slider(
            min: 0,
            max: widget.maxMinutes.toDouble(),
            divisions: widget.maxMinutes ~/ 15,
            value: minutes.toDouble(),
            onChanged: (value) => setState((){ minutes = value.toInt(); }),
            activeColor: Colors.deepPurpleAccent,
            inactiveColor: Colors.white,
          ),

          // Label: Maximum hours
          Text(
            "Based on your weekly availability slots, you can spend maximum ${printDuration(Duration(minutes: widget.maxMinutes))} today.",
            textAlign: TextAlign.left,
            style: GoogleFonts.raleway(
              color: Colors.white.withOpacity(0.6),
            ),
          ),

          Spacer(),

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
