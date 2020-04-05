import 'package:TimeTek/model/assignment.dart';
import 'package:TimeTek/provider/assignment_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<AssignmentDataProvider, List<Assignment>>(
      selector: (ctx, provider) => provider.assignments,
      builder: (BuildContext context, List<Assignment> list, Widget child) {
        if (list == null || list.isEmpty) {

          // A text showing that there's no data available yet.
          return Center(
            child: Text("You don't have any assignments yet."),
          );
        } else {

          // List of items.
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              Assignment item = list[index];
              return ListTile(
                onTap: () {},
                title: Text(item.title, style: GoogleFonts.raleway(color: Colors.white)),
                subtitle: Text("Due on ${DateFormat("yyyy-MM-dd").format(item.endDate)}",
                    style: GoogleFonts.raleway(color: Colors.grey)),
                leading: Icon(Icons.today),
                trailing: item.finished != null && item.finished
                ? Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                )
                : Icon(
                  Icons.check_circle_outline,
                  color: Colors.white.withOpacity(0.1),
                ),
              );
            },
          );
        }
      },
    );
  }
}
