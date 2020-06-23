import 'package:TimeTek/model/assignment.dart';
import 'package:TimeTek/provider/assignment_data.dart';
import 'package:TimeTek/util/helpers_and_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddAssignmentScreen extends StatefulWidget {
  @override
  _AddAssignmentScreenState createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  Assignment _assignment = Assignment();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, (){

      var input = ModalRoute.of(context).settings.arguments;

      if(input != null && input is String){

        // TODO we can do some kind of natural language processing here.
        // Currently adding a very simple NLP that will process the format
        //   "Add xyz for n hours with description abcd"
        Map simpleNLP = _doSimpleNLP(input);

        if(simpleNLP != null && simpleNLP.length > 0){

          // Got some results!

          // Title?
          if(simpleNLP["title"] != null){
            _assignment.title = simpleNLP["title"];
            _titleController.text = simpleNLP["title"];
          } else {
            _assignment.title = input;
            _titleController.text = input;
          }

          // Description?
          if(simpleNLP["description"] != null){
            _assignment.notes = simpleNLP["description"];
            _descController.text = simpleNLP["description"];
          }

          // Hours?
          if(simpleNLP["hours"] != null){
            _assignment.hours = simpleNLP["hours"];
          }

        } else {
          _assignment.title = input;
          _titleController.text = input;
        }

      }

      setState(() {});

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          "Add Assignment",
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Assignment title
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6), border: Border.all(color: Color(0xFF8563EA), width: 2)),
                  child: TextField(
                    controller: _titleController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.raleway(),
                    onChanged: (text) {
                      _assignment.title = text;
                    },
                    decoration: InputDecoration(
                        hintText: "Assignment Title", border: InputBorder.none, contentPadding: EdgeInsets.all(4)),
                  ),
                ),

                // Assignment Description
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6), border: Border.all(color: Color(0xFF8563EA), width: 2)),
                  child: TextField(
                    controller: _descController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.raleway(),
                    minLines: 4,
                    maxLines: 7,
                    onChanged: (text) {
                      _assignment.notes = text;
                    },
                    decoration: InputDecoration(
                      hintText: "Assignment Details",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),// Assignment Description

                // Assignment total hours required
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 4),
                  child: Text(
                    "Total Hours Reqiuired ${ _assignment.hours != null && _assignment.hours > 0 ? ": ${_assignment.hours}" : ": Please choose below"}",
                    style: GoogleFonts.raleway(
                      fontSize: 14
                    ),
                  ),
                ),

                Slider(
                  min: 0,
                  max: 40,
                  divisions: 40,
                  value: _assignment.hours?.toDouble() ?? 0,
                  onChanged: (value) => setState(() => _assignment.hours = value.toInt()),
                  activeColor: Colors.deepPurpleAccent,
                  inactiveColor: Colors.white,
                ),

                // Start & End Dates
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // Start Date
                    RaisedButton(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            width: 2,
                            color: Theme.of(context).primaryColor,
                          )),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.today,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            _assignment.startDate == null
                                ? "Start Date"
                                : DateFormat("MM/dd/yyyy").format(_assignment.startDate),
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () => _selectStartDate(context),
                    ),

                    // End Date
                    RaisedButton(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            width: 2,
                            color: Theme.of(context).primaryColor,
                          )),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.today,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            _assignment.endDate == null
                                ? "End Date"
                                : DateFormat("MM/dd/yyyy").format(_assignment.endDate),
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () => _selectEndDate(context),
                    ),
                  ],
                ),

                // Space
                SizedBox(
                  height: 32,
                ),

                // Button: Add Assignment
                Center(
                  child: RaisedButton(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        )),
                    child: Text(
                      "Add Assignment",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () => _addAssignment(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _assignment.startDate == null ? DateTime.now() : _assignment.startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _assignment.startDate)
      setState(() {
        _assignment.startDate = picked;
      });
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _assignment.endDate == null ? DateTime.now() : _assignment.endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _assignment.endDate)
      setState(() {
        _assignment.endDate = picked;
      });
  }

  void _addAssignment() async {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

    if (_assignment.title == null || _assignment.title.isEmpty) {
      await showAlert(
        context,
        "Title Required",
        "Please enter a valid title for the assignment.",
      );

      return;
    }

    if (_assignment.startDate == null) {
      await showAlert(
        context,
        "Choose a start date",
        "Please choose a valid start date for the assignment.",
      );

      _selectStartDate(context);

      return;
    }

    if (_assignment.endDate == null) {
      await showAlert(
        context,
        "Choose an end date",
        "Please choose a valid end date for the assignment.",
      );

      _selectEndDate(context);

      return;
    }

    _assignment.finished = false;

    Provider.of<AssignmentDataProvider>(context, listen: false).addAssignment(_assignment).then((_) {
      Navigator.of(context).pop();
    });
  }

  Map _doSimpleNLP(String input){

    Map result = {};

    // Hours
    RegExp expHours = RegExp(r'(\d) hours*', caseSensitive: false);
    RegExpMatch hoursMatch = expHours.firstMatch(input);
    if(hoursMatch != null && hoursMatch.groupCount > 0 && int.tryParse(hoursMatch.group(1)) != null){
      result["hours"] = int.tryParse(hoursMatch.group(1));
    }

    // Title
    RegExp expTitle = RegExp(r'[Add?\s]?(\w*) for', caseSensitive: false);
    RegExpMatch titleMatch = expTitle.firstMatch(input);
    if(titleMatch != null && titleMatch.groupCount > 0){
      result["title"] = titleMatch.group(1);
    }

    // Description
    RegExp expDesc = RegExp(r'with description ([\w\s]+)$', caseSensitive: false);
    RegExpMatch descMatch = expDesc.firstMatch(input);
    if(descMatch != null && descMatch.groupCount > 0){
      result["description"] = descMatch.group(1);
    }

    debugPrint("Simple NLP: $result");

    return result;

  }
}
