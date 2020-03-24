import 'dart:collection';

import 'package:TimeTek/model/assignment.dart';
import 'package:TimeTek/provider/assignment_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

abstract class _ListItem {
  Widget build(BuildContext context);
}

class _HeaderItem implements _ListItem {
  String title;

  _HeaderItem(this.title);

  @override
  Widget build(BuildContext context) {
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
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Text(_assignment.title, style: GoogleFonts.raleway(color: Colors.white)),
      subtitle: Text(_assignment.statusStr,
          style: GoogleFonts.raleway(color: Colors.grey)),
      leading: Icon(Icons.today),
    );
  }
}

class HomeScreen extends StatelessWidget {
  Future<List<_ListItem>> processItems(List<Assignment> items) async {
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
  Widget build(BuildContext context) {
    return Consumer<AssignmentDataProvider>(builder: (_, provider, __) {
      return FutureBuilder<List<_ListItem>>(
        future: provider.loadAssignments().then((_) => processItems(provider.assignments)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          debugPrint("SNAPSHOT: ${snapshot.connectionState} // ${snapshot.data}");

          if (snapshot.connectionState == ConnectionState.done) {
            final List<_ListItem> list = snapshot.data;

            if (list == null || list.isEmpty) {
              return Center(
                child: Text("You don't have any assignments yet."),
              );
            } else {
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) => list[index].build(context),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    });
  }
}
