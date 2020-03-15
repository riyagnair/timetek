import 'package:TimeTek/provider/assignment_data.dart';
import 'package:TimeTek/provider/user_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditSlotsScreen extends StatefulWidget{
  @override
  _EditSlotsScreenState createState() => _EditSlotsScreenState();
}

class _EditSlotsScreenState extends State<EditSlotsScreen> {

  List<int> _slots = [0,0,0,0,0,0,0];

  bool _loadedSlots = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, (){
      Provider.of<AssignmentDataProvider>(context, listen: false)
        .loadWeeklySlots()
        .then((slots){
        this._slots = slots;
        this.setState((){});
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check, color: Colors.green,),
            onPressed: () {
              Provider.of<AssignmentDataProvider>(context, listen: false).saveWeeklySlots(_slots).then((_){
                UserDataProvider().setSlots(true);
                Navigator.of(context).pop();
              });
            },
          )
        ],
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          "Edit Weekly Slots",
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                // Sunday
                _getDayTitle("Sunday", 0),
                _getDaySlider(0),
                SizedBox(height: 16),

                // Monday
                _getDayTitle("Monday", 1),
                _getDaySlider(1),
                SizedBox(height: 16),

                // Tuesday
                _getDayTitle("Tuesday", 2),
                _getDaySlider(2),
                SizedBox(height: 16),

                // Wednesday
                _getDayTitle("Wednesday", 3),
                _getDaySlider(3),
                SizedBox(height: 16),

                // Thursday
                _getDayTitle("Thursday", 4),
                _getDaySlider(4),
                SizedBox(height: 16),

                // Friday
                _getDayTitle("Friday", 5),
                _getDaySlider(5),
                SizedBox(height: 16),

                // Saturday
                _getDayTitle("Saturday", 6),
                _getDaySlider(6),
                SizedBox(height: 16),

              ],
            ),
          ),
        ),
    );
  }

  Widget _getDayTitle(String day, int index){
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        "$day: ${_slots[index]} minutes",
        style: GoogleFonts.raleway(
          fontSize: 18
        ),
      ),
    );
  }

  Widget _getDaySlider(int index){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4)
      ),
      child: Slider(
        min: 0,
        max: 120,
        divisions: 8,
        value: _slots[index].toDouble(),
        onChanged: (value) => setState(() => _slots[index] = value.toInt())
      ),
    );
  }
}