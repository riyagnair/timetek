import 'package:TimeTek/model/assignment.dart';
import 'package:TimeTek/provider/assignment_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

abstract class _ListItem {
  Widget build();
}

class _AssignmentItem implements _ListItem {
  Assignment _assignment;

  _AssignmentItem(this._assignment);

  @override
  Widget build() {
    return ListTile(
      onTap: () {},
      title: Text(_assignment.title, style: GoogleFonts.raleway(color: Colors.white)),
      subtitle: Text("Due on ${DateFormat("yyyy-MM-dd").format(_assignment.endDate)}",
        style: GoogleFonts.raleway(color: Colors.grey)),
      leading: Icon(Icons.today),
    );
  }
}

class HomeScreen extends StatelessWidget {

  Future<List<_AssignmentItem>> processItems(List<Assignment> items) async{
    List<Assignment> l1 = items
      .where((it) => (it.finished == null || it.finished == false))
      .toList();

    l1.sort((a, b) => a.endDate.compareTo(b.endDate));

    List l2 = l1
      .map((m) => _AssignmentItem(m))
      .toList();

    return l2;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentDataProvider>(
      builder: (_, provider, __) {
        return FutureBuilder<List<_ListItem>>(
          future: processItems(provider.assignments),
          builder: (BuildContext context, AsyncSnapshot snapshot) {

            debugPrint("SNAPSHOT: ${snapshot.connectionState} // ${snapshot.data}");

            if (snapshot.connectionState == ConnectionState.done) {
              final List<_ListItem> list = snapshot.data;

              if (list == null || list.isEmpty) {
                return Center(
                  child: Text("You don't have any assignments yet."),
                );
              } else {
                return ListView.builder(itemCount: list.length, itemBuilder: (context, index) => list[index].build());
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      }
    );
  }
}
